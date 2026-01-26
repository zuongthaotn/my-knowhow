1. To start off setting PHP Storm up, we need to tell it which version of PHP we’re writing in, 
lets use PHP 7.2, follow the steps below to configure:
Files => Setting => Languages & Frameworks > PHP => change PHP language level & PHP CLI Interpreter.

2. Then navigate to Test Frameworks:
Preferences > Languages & Frameworks > PHP > Test Frameworks
Click the plus icon in the window to add a new PHPUnit Configuration and select PHPUnit Local
We can use the PHPUnit installed via composer that ships with Magento 2, 
click the three dots in the window and find the autoload.php file in your Magento 2 install, 
it should be in m2/vendor/autoload.php
Apply the changes and close the window. PHP Storm is ready to start running tests. 
This means we can write our tests and run them with ease.

3. New Module for testing, such as OptimizeUnitTest
create new phpunit.xml: app/code/ZT/OptimizeUnitTest/etc/phpunit.xml
```
<?xml version="1.0" encoding="UTF-8"?>
<phpunit
        bootstrap="/var/www/html/gclock.local/app/autoload.php"
        colors="true"
        convertErrorsToExceptions="true"
        convertNoticesToExceptions="true"
        convertWarningsToExceptions="true"
        beStrictAboutTestsThatDoNotTestAnything="false"
        stopOnError="true"
        stopOnFailure="true">
    <testsuites>
        <testsuite name="Magento_Unit_Tests_App_Code">
            <directory suffix="Test.php">../Test/Unit</directory>
        </testsuite>
    </testsuites>
    <php>
        <ini name="date.timezone" value="America/Los_Angeles"/>
        <ini name="xdebug.max_nesting_level" value="200"/>
    </php>
    <filter>
        <whitelist addUncoveredFilesFromWhiteList="true">
            <directory suffix=".php">../../OptimizeUnitTest/*</directory>
            <exclude>
                <directory>../../OptimizeUnitTest/*/Test</directory>
            </exclude>
        </whitelist>
    </filter>
    <logging>
        <log type="testdox-text" target="../testResult/testdox.txt"/>
    </logging>
</phpunit>
```
