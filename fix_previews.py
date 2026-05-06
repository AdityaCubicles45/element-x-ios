import os
import re

directory = "Chatlio/Sources"

for root, _, files in os.walk(directory):
    for filename in files:
        if filename.endswith(".swift"):
            filepath = os.path.join(root, filename)
            with open(filepath, "r") as f:
                content = f.read()

            if "PreviewProvider" not in content:
                continue

            lines = content.split('\n')
            new_lines = []
            in_preview = False
            brace_count = 0

            for line in lines:
                if not in_preview:
                    if "PreviewProvider" in line and "struct " in line:
                        # Before we start commenting, check if it's already commented
                        if "/*" in line and not "*/" in line:
                            # It's inside a multiline comment already maybe?
                            pass
                        
                        # Start commenting
                        in_preview = True
                        brace_count = line.count('{') - line.count('}')
                        new_lines.append("/*")
                        new_lines.append(line)
                        if brace_count == 0 and "{" in line:
                            in_preview = False
                            new_lines.append("*/")
                    else:
                        new_lines.append(line)
                else:
                    new_lines.append(line)
                    brace_count += line.count('{') - line.count('}')
                    if brace_count <= 0:
                        in_preview = False
                        new_lines.append("*/")

            with open(filepath, "w") as f:
                f.write('\n'.join(new_lines))
