package main

# Rule 1: NIS2 Article 21 - Restrict Privileged Containers
deny[msg] {
    input.kind == "Deployment"
    container := input.spec.template.spec.containers[_]
    container.securityContext.privileged == true
    msg := sprintf("NIS2 Violation: Container '%v' in Deployment '%v' cannot run in privileged mode.", [container.name, input.metadata.name])
}

# Rule 2: NIS2 Article 21 - Enforce Non-Root Execution
deny[msg] {
    input.kind == "Deployment"
    not input.spec.template.spec.securityContext.runAsNonRoot == true
    msg := sprintf("NIS2 Violation: Deployment '%v' must explicitly set 'securityContext.runAsNonRoot: true'.", [input.metadata.name])
}

# Rule 3: NIS2 Article 21 - Image Tag Governance & Traceability
deny[msg] {
    input.kind == "Deployment"
    container := input.spec.template.spec.containers[_]
    endswith(container.image, ":latest")
    msg := sprintf("NIS2 Violation: Container '%v' uses mutable tag ':latest' in Deployment '%v'. Specify an explicit version tag.", [container.name, input.metadata.name])
}
