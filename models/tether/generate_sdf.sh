# Parameters
JOINT2_AXIS="0 0 1"
JOINT2_FRICTION=0
JOINT2_DAMPING=0.01
JOINT2_SPRING_STIFFNESS=0

# Generate URDF from XACRO
xacro model.xacro > model.urdf

# Generate SDF from URDF
gz sdf -p model.urdf > model.sdf

# Find and replace in the sdf file to add features to the SDF not available in URDF
# Swap to universal joint and add second axis
sed -i 's/revolute/universal/g' model.sdf
perl -i -pe 'BEGIN{undef $/;} s|      <\/axis>\n    <\/joint>|      </axis>\n      <axis2>\n        <xyz>'"${JOINT2_AXIS}"'</xyz>\n        <limit>\n          <lower>-inf</lower>\n          <upper>inf</upper>\n        </limit>\n        <dynamics>\n          <damping>'"${JOINT2_DAMPING}"'</damping>\n          <friction>'"${JOINT2_FRICTION}"'</friction>\n          <spring_reference>0</spring_reference>\n          <spring_stiffness>'"${JOINT2_SPRING_STIFFNESS}"'</spring_stiffness>\n        </dynamics>\n      </axis2>\n    </joint>|gsm' model.sdf

