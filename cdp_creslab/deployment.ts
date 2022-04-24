import { Construct, Stage } from "@aws-cdk/core";
import { CreslabStageProps, CreslabEnvironProps } from "./props";
import { loadYaml } from "../common/functions";
import { CreslabStatelessStack } from "../cdp_cdk_stacks/creslab_stateless";

export class CreslabStage extends Stage {
  constructor(scope: Construct, id: string, props: CreslabStageProps) {
    super(scope, id, props);

    const ctx = loadYaml("creslab", props.environ) as CreslabEnvironProps;

    //Creslab stacks
    new CreslabStatelessStack(this, "CreslabStateless", {
      s3BucketNames: ctx.s3BucketNames,
      vpcId: ctx.vpcId,
      creslabSecretName: ctx.creslabSecretName,
    });
  }
}
