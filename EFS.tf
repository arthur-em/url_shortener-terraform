
# Create EFS (Elastic File System

resource "aws_efs_file_system" "efs" {

}

resource "aws_efs_mount_target" "mount_a" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.app_a.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "mount_b" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.app_b.id
  security_groups = [aws_security_group.efs_sg.id]
}