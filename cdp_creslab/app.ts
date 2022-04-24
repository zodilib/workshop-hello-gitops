import { App } from "@aws-cdk/core";
import { CreslabStage } from "./deployment";
import * as pkg from "../package.json";

const app = new App();
const environ: string = app.node.tryGetContext("environ");
let account;
if (environ == "dev") account = pkg.ssoCredentialProvider.cdp.dev;
else if (environ == "staging") account = pkg.ssoCredentialProvider.cdp.staging;
else if (environ == "prod") account = pkg.ssoCredentialProvider.cdp.prod;
else throw new Error("Wrong environ. Must be dev/staging/prod.");

new CreslabStage(app, `${environ}Creslab`, {
  environ: environ,
  tenants: ["money101"],
  env: {
    account: account,
    region: "ap-southeast-1",
  },
});
app.synth();
