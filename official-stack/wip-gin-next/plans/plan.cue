package plans

import (
	"dagger.io/dagger"
	"github.com/h8r-dev/stacks/chain/v3/stack"
)

dagger.#Plan & {
	client: {
		commands: kubeconfig: {
			name: "cat"
			args: [env.KUBECONFIG]
			stdout: dagger.#Secret
		}
		env: {
			ORGANIZATION:    string
			GITHUB_TOKEN:    dagger.#Secret
			KUBECONFIG:      string
			APP_NAME:        string
			APP_DOMAIN:      string | *"h8r.site"
			NETWORK_TYPE:    string | *"default"
			REPO_VISIBILITY: string | *"private"
			ENV_NAME:        string | *"main"
		}
	}
	actions: up: stack.#Install & {
		args: {
			name:           client.env.APP_NAME
			domain:         client.env.APP_DOMAIN
			networkType:    client.env.NETWORK_TYPE
			repoVisibility: client.env.REPO_VISIBILITY
			organization:   client.env.ORGANIZATION
			githubToken:    client.env.GITHUB_TOKEN
			kubeconfig:     client.commands.kubeconfig.stdout
			envName:        client.env.ENV_NAME
			frameworks: [
				{
					name: "gin"
				},
				{
					name: "next"
				},
			]
			addons: [
				{
					name: "nocalhost"
				},
				{
					name: "prometheus"
				},
			]
		}
	}
}
