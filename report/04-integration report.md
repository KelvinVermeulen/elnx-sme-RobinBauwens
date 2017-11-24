# Enterprise Linux Lab Report

- Student name: Robin Bauwens
- Github repo: <https://github.com/HoGentTIN/elnx-sme-RobinBauwens/tree/solution>

Het opzetten van een server met DHCP en een router via Ansible.

## Test plan

How are you going to verify that the requirements are met? The test plan is a detailed checklist of actions to take, including the expected result for each action, in order to prove your system meets the requirements. Part of this is running the automated tests, but it is not always possible to validate *all* requirements throught these tests.

### DHCP
- De DHCP-service moet correct geconfigureerd zijn.
  - 
  

## Procedure/Documentation

1. Voeg de role `bertvv.dhcp` toe in `site.yml`:
```
- hosts: pr001
  roles:
    - bertvv.rh-base
    - bertvv.dhcp
```
2. Voer dan script `role-deps.sh` uit op je hostmachine. Voeg ook volgende code toe bij `vagrant-hosts.yml`:
```
- name: pr001
  ip: 172.16.0.2
```

3. [Voeg code toe](https://github.com/HoGentTIN/elnx-sme-RobinBauwens/blob/solution/ansible/host_vars/pr001.yml) voor `dhcp_global_classes` (om alle MAC-adressen, die uitgedeeld worden door VirtualBox, een IP-adres te geven), de domeinnaam, de standaard uitleentijd, de DNS-servers, DHCP-hosts (adhv MAC-adres) en DHCP-subnets (o.a. netwerkadres, default gateway, begin-, en eindbereik van de pools, en verdere configuratie in te stellen. We definiëren 1 pool tussen `172.16.128.1-172.16.191.254`: hierin gaan we enkel de IP-adressen uitdelen adhv het MAC-adres (dat meegegeven werd bij `dhcp-hosts`). Daarom zetten we er ook een `deny` op de "`vbox`-klasse" omdat we niet nog eens een IP-adres aan dezelfde interface willen toekennen. Ten slotte maken we ook een pool voor de hosts waarbij we geen MAC-adres specifiëren. Deze krijgt dan het bereik tussen `172.16.192.1-172.16.255.253`.

4. Om de DHCP-configuratie te testen, maken we een VM met Fedora en 2 host-only interfaces. We kiezen voor host-only adapter #6 (kan verschillen), dit is voor `172.16.0.1/16`.



Describe *in detail* how you completed the assignment, with main focus on the "manual" work. It is of course not necessary to copy/paste your code in this document, but you can refer to it with a hyperlink.

Make sure to write clean Markdown code, so your report looks good and is clearly structured on Github.

## Test report

The test report is a transcript of the execution of the test plan, with the actual results. Significant problems you encountered should also be mentioned here, as well as any solutions you found. The test report should clearly prove that you have met the requirements.

- Host-only adapters van nieuwe VM niet verwarren met adapters van hostmachine! Is adhv host-only adapter #6.
- Bij de pool die de machines voorziet van een IP-adres adhv het (volledig) meegegeven MAC-adres, moet je ook een `deny` zetten op de global class!

## Resources

List all sources of useful information that you encountered while completing this assignment: books, manuals, HOWTO's, blog posts, etc.
