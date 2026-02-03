variable "credentials" {
    description = "My GCP Credentials"
    default     = "/tmp/gcp-key-terraform.json"
}

variable "project" {
    description = "Project"
    default     = "data-engineering-course-486123"
}

variable "region" {
    description = "Region"
    #Update the below to your desired region
    default     = "us-central1"
}

variable "location" {
    description = "Project Location"
    #Update the below to your desired location
    default     = "us-central1"
}

variable "bq_dataset_name" {
    description = "My BigQuery Dataset Name"
    #Update the below to what you want your dataset to be called
    default     = "ny_taxi_dataset_homework3"
}

variable "gcs_bucket_name" {
    description = "My Storage Bucket Name"
    #Update the below to a unique bucket name
    default     = "data-engineering-course-486123-homework3-bucket"
}

variable "gcs_storage_class" {
    description = "Bucket Storage Class"
    default     = "STANDARD"
}