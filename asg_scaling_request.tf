resource "aws_autoscaling_policy" "alb_req_per_target" {
  name                   = "alb-req-per-target"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.flask_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_lb.flask_alb.arn_suffix}/${aws_lb_target_group.flask_tg.arn_suffix}"
      # resource_label : 어떤 ALB + 어떤 Target Group의 요청량을 기준으로 스케일링할지”를 정확히 지정하는 식별자
    }

    target_value = 100.0
  }
}

