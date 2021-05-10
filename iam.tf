# CREATE IAM USERS
resource "aws_iam_user" "ezeja" {
  name = "ezeja"
}

resource "aws_iam_user" "chika" {
 name = "chika" 
}

# define the name of the aws group
resource "aws_iam_group" "developer" {
  name = "developer"
}

# associate users to member of a group
resource "aws_iam_group_membership" "developers" {
  name = "developers"
  users = [aws_iam_user.ezeja.name, aws_iam_user.chika.name ]
  group = aws_iam_group.developer.name
}

# attach the policies to group
## if you use the AdministratorAccess, do not use terraform destroy
resource "aws_iam_policy_attachment" "developers_policy" {
  name = "developers-user-policy"
  groups = [aws_iam_group.developer.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}