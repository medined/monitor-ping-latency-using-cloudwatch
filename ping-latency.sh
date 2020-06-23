ping -c 1 bbc.com | head -n 2 | tail -n 1 | cut -d'=' -f4 | cut -d' ' -f1
