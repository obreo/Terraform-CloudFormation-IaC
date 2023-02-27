### SNS Topic 

# 1- Topic
resource "aws_sns_topic" "sns_topic" {
  name = "SNS_Topic"
}
# 2- Assign Topic with policy for SNS (Allow Role or user to use SNS)
resource "aws_sns_topic_policy" "attach_sns" {
  arn    = aws_sns_topic.sns_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_Policy.json
}
# 2.1 - Policy
data "aws_iam_policy_document" "sns_topic_Policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.sns_topic.arn,
    ]

    sid = "__default_statement_ID"
  }

}

# 3- Subscribe of SNS
resource "aws_sns_topic_subscription" "sns_subscribers" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = "EMAIL_ADDRESS"
}


