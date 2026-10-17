import re
import json

# Let's read parsed_flow.txt and extract all questions
with open(r"d:\doan\ktra\parsed_flow.txt", "r", encoding="utf-8") as f:
    text = f.read()

# Let's inspect all question numbers present
q_matches = re.findall(r'\b(1[0-9]{2}|200)\b', text)
unique_qs = sorted(list(set(int(x) for x in q_matches if 101 <= int(x) <= 200)))
print(f"Found {len(unique_qs)} unique question numbers between 101 and 200: {min(unique_qs)} -> {max(unique_qs)}")
