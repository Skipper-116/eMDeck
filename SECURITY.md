# Security Policy

## Supported Versions

The following versions of eMDeck are actively supported with security updates:

| Version | Supported |
| ------- | --------- |
| 1.x     | ✅        |
| < 1.0   | ❌        |

---

## Reporting a Vulnerability

If you discover a security vulnerability in eMDeck, please follow these steps to report it:

1. **Email the Security Team**:
   Send an email to [security@yourdomain.com](mailto:security@yourdomain.com) with the following details:

   - A detailed description of the vulnerability.
   - Steps to reproduce the issue.
   - Any potential impact of the vulnerability.
   - Optionally, suggestions for fixing the issue.

2. **Do Not Disclose Publicly**:

   - Please do not disclose the vulnerability until we have had a chance to investigate and release a fix.

3. **Acknowledgment**:

   - We will acknowledge receipt of your email within **48 hours**.
   - We aim to provide an initial response, including a timeline for remediation, within **7 days**.

4. **Responsible Disclosure**:
   - Once the vulnerability is resolved, we will release an advisory with proper credit to the discoverer, unless they wish to remain anonymous.

---

## Security Update Process

1. **Patch Release**:

   - Security patches will be backported to all supported versions.

2. **Advisory Publication**:
   - A public advisory will be issued via the [repository's Security Advisory page](https://github.com/your-org/emdeck/security/advisories).

---

## General Security Best Practices

To ensure your deployment of eMDeck is secure:

1. **Keep Dependencies Updated**:
   - Regularly update Docker images, Ruby gems, and Node.js dependencies.
2. **Use Secure Configuration**:
   - Follow the deployment guidelines in the `README.md`.
3. **Limit Access**:
   - Restrict access to services like MySQL, Redis, and Nginx to trusted IPs.
4. **Monitor Logs**:
   - Regularly review logs to detect unusual activity.

---

Thank you for helping to make eMDeck secure for everyone!
