output "gitlab-manager" {
  value = "gcloud compute ssh --project=${var.gcp_project_id} --zone=${var.gcp_zone} ${google_compute_instance.gitlab_manager.name}"
  description = "String to SSH into a GitLab manager VM"
}
