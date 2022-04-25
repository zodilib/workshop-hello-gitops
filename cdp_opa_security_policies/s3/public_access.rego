package s3.public_access

resource_type = "AWS::S3::Bucket"
 
default allow = true

allow = false {
    count(violation) > 0
}

violation[retVal] {
    count(block_public_access) > 0
    retVal := { msgJson |
        s3 = block_public_access[_]
        msgJson := {
            "resource": s3,
            "decision": "deny",
            "message": "The Bucket is not blocked for Public Access"
        }
    }
}

block_public_access[resource] {
    some resource
    input.Resources[resource].Type == resource_type
    
    s := [
    input.Resources[resource].Properties.PublicAccessBlockConfiguration.BlockPublicAcls,
    input.Resources[resource].Properties.PublicAccessBlockConfiguration.BlockPublicPolicy,
    input.Resources[resource].Properties.PublicAccessBlockConfiguration.IgnorePublicAcls,
    input.Resources[resource].Properties.PublicAccessBlockConfiguration.RestrictPublicBuckets,
    ]
    not s == [true, true, true, true]
   
   }