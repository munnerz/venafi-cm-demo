# venafi-cm-demo

This repository contains a script that can be used to quickly provision
a demo environment to show cert-manager with Venafi integration.

It is compatible with Linux and OSX, and only requires Docker in order
to run.

Any additional required dependencies will be pulled automatically.

## Usage

To get started, simply run:

```bash
$ git clone https://github.com/munnerz/venafi-cm-demo.git
$ cd venafi-cm-demo/
$ ./start-demo.sh

...

All components have been deployed!

Please run the following command to make 'kubectl' work:

	export PATH=/Users/james/go/src/github.com/munnerz/venafi-cm-demo/bin:${PATH}
	export KUBECONFIG=$(kind get kubeconfig-path --name venafi)
```

It may take up to 2 minutes to provision the environment.
Once the script has completed, you will need to wait until cert-manager
has finished 'pulling' and has started running.

You can check this by running:

```bash
$ kubectl get pods -n cert-manager
NAME                                    READY   STATUS      RESTARTS   AGE
cert-manager-84678d8c7d-psb8l           1/1     Running     0          26m
cert-manager-webhook-7bd75779fc-t7nzd   1/1     Running     0          26m
cert-manager-webhook-ca-sync-4mpmf      0/1     Completed   2          26m
```

As you can see above, the pods in the 'cert-manager' namespace have all started
or completed successfully.

It may take a few minutes to start, depending on your internet connection speed.

Once all the pods are running, you should create the Venafi Issuer resource along
with any corresponding Certificate resources you want to demonstrate.

## Issues

If you encounter any issues whilst running this script, please
open an issue on this repository.

