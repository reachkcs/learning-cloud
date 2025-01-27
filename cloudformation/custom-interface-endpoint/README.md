1. Create NLB and web service using template service-ieps.yaml
    ```../../bin/create-or-update-cw-stack.bash service-ieps.yaml KCSTEMP-SERVICE-IEPS YES```
2. Create custoemr VPC, test EC2s etc using template test-custom-iep.yaml
    ```../../bin/create-or-update-cw-stack.bash test-custom-iep.yaml KCSTEMP-CUSTOM-IEP YES```
3. Create the endpoint service using the already created NLB and endpoint in customer private subnet using template endpoint-service.yaml
    ```../../bin/create-or-update-cw-stack.bash endpoint-service.yaml KCSTEMP-ENDPOINTS NO```