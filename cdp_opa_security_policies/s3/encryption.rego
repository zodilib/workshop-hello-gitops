package s3.bucket_encryption

# bucket resource in the file
resource_type = "AWS::S3::Bucket"

allowed_sse_algorithms = {
  "AES256"
}

default allow = true

allow = false {
    count(violation) > 0
}

violation[retVal] {
    count(deny_sse_algorithm) > 0
    retVal := { msgJson |
        s3 = deny_sse_algorithm[_]
        msgJson := {
            "resource": s3,
            "decision": "deny",
            "message": sprintf("S3 bucket server side encryption (SSE) is required. Objects can be encrypted **only** with allowed_sse_algorithms %s", [allowed_sse_algorithms])
        }
    }
}

violation[retVal] {
    count(deny_without_sse) > 0
    retVal := { msgJson |
        s3 = deny_without_sse[_]
        msgJson := {
            "resource": s3,
            "decision": "deny",
            "message": "S3 bucket server side encryption (SSE) is required. Please enable BucketEncryption to protect data-at-rest."
        }
    }
}

deny_sse_algorithm[resource] {
    some resource
    input.Resources[resource].Type == resource_type
    algorithms := { algorithm |
        algorithm := input.Resources[resource].Properties.BucketEncryption.ServerSideEncryptionConfiguration[_].ServerSideEncryptionByDefault.SSEAlgorithm
    }
    count(algorithms) > 0
    count(algorithms - allowed_sse_algorithms) > 0
}

deny_without_sse[resource] {
    some resource
    input.Resources[resource].Type == resource_type
    not input.Resources[resource].Properties.BucketEncryption
}

