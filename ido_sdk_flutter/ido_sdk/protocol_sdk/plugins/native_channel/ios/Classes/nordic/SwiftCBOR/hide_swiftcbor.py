import os
import re

directory = "/Users/hc/Documents/work2.0/ido_workspace/protocol_sdk/plugins/native_channel/ios/Classes/nordic/SwiftCBOR"

for root, _, files in os.walk(directory):
    for file in files:
        if file.endswith(".swift"):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Replace public and open with internal
            content = re.sub(r'\bpublic\s+', 'internal ', content)
            content = re.sub(r'\bopen\s+', 'internal ', content)
            
            with open(path, 'w', encoding='utf-8') as f:
                f.write(content)

print("Privatization complete.")
