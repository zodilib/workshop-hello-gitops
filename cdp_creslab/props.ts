import { StackProps, StageProps } from "@aws-cdk/core";

export interface CidrsProps {
  app: string[];
  data: string[];
  metabase: string[];
}

export interface S3BucketNamesProps {
  data: string;
  firehoseLogging: string;
}

interface EnvProps {
  account: string;
  region: string;
}
export interface CreslabStageProps extends StageProps {
  environ: string;
  tenants: string[];
  env: EnvProps;
}

export interface CreslabEnvironProps {
  creslabSecretName: string;
  cidrs: CidrsProps;
  s3BucketNames: S3BucketNamesProps;
  supportEmailRecipients: string[];
  region: string;
  vpcId: string;
}

export interface CreslabStatelessStackProps extends StackProps {
  s3BucketNames: S3BucketNamesProps;
  vpcId: string;
  creslabSecretName: string;
}
