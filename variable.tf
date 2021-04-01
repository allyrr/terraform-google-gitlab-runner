
variable "gcp_gitlab_resource_prefix" {
  type        = string
  default     = "gitlab"
  description = "Name prefix for all the resources"
}
variable "gcp_gcs_cache_age" {
  type        = number
  default     = 60
  description = "Time in days to keep the GitLab's cache in the GCS bucket"
}
variable "gcp_project_id" {
  type        = string
  description = "GCP project id"
}
variable "gitlab_registration_token" {
  type        = string
  description = "Registration token. Can be found under Settings > CI/CD and expand the Runners section of group you want to make the runner work for"
}
variable "gitlab_docker_machine_release" {
  type        = string
  default     = "v0.16.2-gitlab.11"
  description = "Release version of forked docker-machine. Available releases: https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/releases "
}
variable "gcp_zone" {
  type        = string
  description = "GCP default zone"
}
variable "gcp_main_vpc_sub_ip_range" {
  type        = string
  default     = "10.10.0.0/20"
  description = "GCP default subnetwork ip range"
}
variable "gcp_region" {
  type = string
  description = "GCP default region"
}
variable "gitlab_register_runner" {
  type        = any
  description = "Map of different GitLab runners and their attributes. For more info refer 1) Google Machine drivers - https://docs.docker.com/machine/drivers/gce/ and 2) GitLab One-line registration command https://docs.gitlab.com/runner/register/#one-line-registration-command"
}
