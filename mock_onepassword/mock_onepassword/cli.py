#!/usr/bin/env python3
import secrets


def main():
    print(secrets.token_urlsafe(12))


if __name__ == '__main__':
    main()
