Welcome to wikipage about Unit testing in PlatformIO
Here you can find information about the testing structure and how to use the testing framework with PlatformIO. 


## General information about unit testing

PlatformIO has created an infrastructure to test code natively on the development machine and on embedded devices.

The PlatformIO testing framework works as follows: All tests need to be in the test folder. Within this folder, you can place your tests.

It is a good practice to separate tests by platform, as shown in Figure 1.
```
test
├── native
│   ├─ test_function_test1
│   │  ├─ source files e.g. foo.h
│   │  └─ source files e.g. bar.cpp
│   │
│   └─ test_function_test2
│      ├─ source files e.g. foo.h
│      └─ source files e.g. bar.cpp
│
└── embedded
    ├─ test_function_test1
    │  ├─ source files e.g. foo.h
    │  └─ source files e.g. bar.cpp
    │
    └─ test_function_test2
       ├─ source files e.g. foo.h
       └─ source files e.g. bar.cpp 

```
_**Figure 1:** Basic infrastructure of a unit test_

For more information about testing and PlatformIO, visit [testing and PlatfromIO](https://docs.platformio.org/en/stable/advanced/unit-testing/structure/hierarchy.html)


### Prerequisites

- All tests are in the `test/` folder
- Every test is present in a folder starting with `test_`
- Every test file contains `int main()`
- Have the enviroment setup in `platformio.ini`


### how to run the unit tests

To execute you need to have a terminal available and have the plaform defined in the `platformio.ini` file.
Example:
```
[env:native]
platform = native
```

after the enviroment is set, then you can run the tests.
To run all the tests, use the following command:
```bash
pio test e native -vvv
```

if you want to run only want to run one test, and you have the structure like figure 2, then use the following command:
```bash
pio test e native --filter="native/test_foo" -vvv
```


```
test
└── native
    ├─ test_foo
    │  ├─ source files e.g. foo.h
    │  └─ source files e.g. foo.cpp
    │
    └─ test_bar
       ├─ source files e.g. bar.h
       └─ source files e.g. bar.cpp
```
_**Figure 2:**  another example of a testing structure._









