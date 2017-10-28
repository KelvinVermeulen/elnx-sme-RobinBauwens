# Enterprise Linux Lab Report

- Student name: Robin Bauwens
- Github repo: <https://github.com/HoGentTIN/elnx-sme-RobinBauwens/tree/solution>

Installeren van Samba voor de (publieke) fileserver met Vagrant en Ansible.

## Test plan

How are you going to verify that the requirements are met? The test plan is a detailed checklist of actions to take, including the expected result for each action, in order to prove your system meets the requirements. Part of this is running the automated tests, but it is not always possible to validate *all* requirements throught these tests.

## Procedure/Documentation

1. We voegen `pr011` toe bij `site.yml`, we geven deze de rollen van `rh-base` en `samba`. ![Git Bash](img/03/1.PNG)
2. Hierna voegen we `pr011` ook toe bij `vagrant-hosts.yml`, we geven de server `172.16.0.11` als IP-adres. ![Git Bash](img/03/2.PNG)
3. Voor deze role hebben we enkele gebruikers en een groep nodig, deze voegen we toe bij de `rh-base`-role. ![Git Bash](img/03/4.PNG)
4. De paswoorden dienen geëncrypteerd te zijn, dit doen we op dezelfde manier als in de eerste opdracht. ![Git Bash](img/03/3.png)
```
$ openssl passwd -salt 1 -1 ecila
$1$1$9r7dwD12SuyxP9p1L46w11

$ openssl passwd -salt 1 -1 bob
$1$1$StRVYKTEpypIa2lYbrCdw1

$ openssl passwd -salt 1 -1 eilrahc
$1$1$QnWg3wSB/7eRvp0.DmAg5/
```

Describe *in detail* how you completed the assignment, with main focus on the "manual" work. It is of course not necessary to copy/paste your code in this document, but you can refer to it with a hyperlink.

Make sure to write clean Markdown code, so your report looks good and is clearly structured on Github.

## Test report

The test report is a transcript of the execution of the test plan, with the actual results. Significant problems you encountered should also be mentioned here, as well as any solutions you found. The test report should clearly prove that you have met the requirements.

## Resources

List all sources of useful information that you encountered while completing this assignment: books, manuals, HOWTO's, blog posts, etc.

- [Lezen .csv BASH](https://www.cyberciti.biz/faq/unix-linux-bash-read-comma-separated-cvsfile/)