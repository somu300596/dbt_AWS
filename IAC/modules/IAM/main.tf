resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = jsonencode(var.assume_role_policy)
}

data "aws_iam_policy_document" "policy" {
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      effect    = statement.value["Effect"]
      actions   = statement.value["Action"]
      resources = statement.value["Resource"]
    }
  }
}

resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
