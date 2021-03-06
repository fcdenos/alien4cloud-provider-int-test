Feature: Linux with cloudify 3
  # Tested features with this scenario:
  #   - Instantiation of Linux VM
  #   
  Scenario: Usage of linux with cloudify 3
    Given I am authenticated with "ADMIN" role

    # Archives
    And I checkout the git archive from url "https://github.com/alien4cloud/tosca-normative-types.git" branch "master"
    And I upload the git archive "tosca-normative-types"
    And I checkout the git archive from url "https://github.com/alien4cloud/alien4cloud-extended-types.git" branch "master"
    And I checkout the git archive from url "https://github.com/alien4cloud/samples.git" branch "master"
    And I upload the git archive "alien4cloud-extended-types/alien-base-types-1.0-SNAPSHOT"
    And I upload the local archive "topologies/linux_simple.yaml"

    # Cloudify 3
#    And I upload a plugin from maven artifact "alien4cloud:alien4cloud-cloudify3-provider"
    And I upload a plugin from "../alien4cloud-cloudify3-provider"

    # Orchestrator and location
    And I create an orchestrator named "virtual Sphere orchestra" and plugin name "alien-cloudify-3-orchestrator" and bean name "cloudify-orchestrator"
    And I get configuration for orchestrator "virtual Sphere orchestra"
    And I update cloudify 3 manager's url to value defined in environment variable "VSPHERE_CLOUDIFY3_MANAGER_URL" for orchestrator with name "virtual Sphere orchestra"
    And I enable the orchestrator "virtual Sphere orchestra"
    And I create a location named "Harp location" and infrastructure type "vsphere" to the orchestrator "virtual Sphere orchestra"

    And I create a resource of type "alien.cloudify.vsphere.nodes.Compute" named "NormalLinux" related to the location "virtual Sphere orchestra"/"Harp location"
    And I update the property "template" to "UbuntuNewCfyTemplate" for the resource named "NormalLinux" related to the location "virtual Sphere orchestra"/"Harp location"
    And I update the property "user" to "uzer" for the resource named "NormalLinux" related to the location "virtual Sphere orchestra"/"Harp location"
    And I update the property "cpus" to "1" for the resource named "NormalLinux" related to the location "virtual Sphere orchestra"/"Harp location"
    And I update the property "memory" to "2048" for the resource named "NormalLinux" related to the location "virtual Sphere orchestra"/"Harp location"
    And I update the property "primary_network_name" to "VM Network" for the resource named "NormalLinux" related to the location "virtual Sphere orchestra"/"Harp location"
    And I update the property "primary_network_is_external" to "true" for the resource named "NormalLinux" related to the location "virtual Sphere orchestra"/"Harp location"

    And I create a new application with name "linuxvspherecompute" and description "Linux with CFY 3" based on the template with name "linux_simple"
    And I Set a unique location policy to "virtual Sphere orchestra"/"Harp location" for all nodes

    When I deploy it
    Then I should receive a RestResponse with no error
    And The application's deployment must succeed after 25 minutes