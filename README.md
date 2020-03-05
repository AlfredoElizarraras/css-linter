
---

# CSS Linter

> This project is completed by Oscar Alfredo Gómez Elizarrarás, in partial requirements of the Microverse cirriculum. 

---

## Built With

- Ruby 2.6.5

---

### Prerequisites

- Ruby 2.6.5

### Install

`git clone https://github.com/AlfredoElizarraras/css-linter.git`

#### On command line:
`bundler install`

### Use

1. Before running the linter, it needs a yaml file in the root directory, named checks.yml with the property 'Enabled: true' in the checks we want to perform.
 - Example of checks:
 ```
  --- 
  Checks:
  - spaces_before_first_brace:
    - Enabled: true
  - spaces_after_first_brace:
    - Enabled: true
  - rules_indentation:
    - Enabled: true
  - space_after_colon:
    - Enabled: false
  - no_uppcase_selectors:
    - Enabled: false
 ```
2. Then we call the linter adding the path of the file we want to check.
  - For example:
  ```
  ruby bin/main.rb examples/styles.css
  ```
3. We will get the feedback from the linter with the total and details of errors and/or warnings we want to change.
  - Example of output:
  ```
    Number of errors: 8

    Messages from spaces_before_first_brace:
      - There's a missing space at line:  1
      - There's a missing space at line:  6

    Messages from spaces_after_first_brace:
      - There's an extra space at line:  6

    Messages from rules_indentation:
      - Theres's missing indentation of 1 space at line:  2
      - Theres's missing indentation of 1 space at line:  3
      - Theres's missing indentation of 2 spaces at line:  7

    Messages from space_after_colon:
      - There's missing a space after colon at line:  7

    Messages from check_no_uppcase_selectors:
      - Detected uses of upper-case in selector at line:  6

  ```


## Authors

👤 **Oscar Alfredo Gómez Elizarrarás**

- Github: [@AlfredoElizarraras](https://github.com/AlfredoElizarraras)
- Twitter: [@OscarAlfredoGm4](https://twitter.com/OscarAlfredoGm4)
- Linkedin: [@OscarAlfredoGómezElizarrarás](https://mx.linkedin.com/in/oscar-alfredo-gomez-elizarraras-999589186)

---

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](https://github.com/AlfredoElizarraras/css-linter/issues).

## Show your support

Give a ⭐️ if you like this project!

## Acknowledgments

- [Microverse](https://microverse.org)

---

## 📝 License

This project is [MIT](https://github.com/AlfredoElizarraras/css-linter/blob/develop/LICENSE) licensed.

Copyright 2019 Oscar Alfredo Gómez Elizarrarás

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---
