import dns.resolver

def nslookup(domain):
    try:
        # Resolve the domain
        result = dns.resolver.resolve(domain, 'A')

        # Collect the results
        addresses = [ipval.to_text() for ipval in result]
        return '\n'.join(addresses)
    except Exception as e:
        return str(e)

# Example usage
domain = "example.com"
output = nslookup(domain)
print(output)
