load_search_index({"pages":[{"title":"Version 0.x","text":"#Version 0.x Caution \u201cCMake Scripts\u201d is still in development. You SHOULD NOT use this packages in a production environment. Breaking changes MUST be expected for all v0.x releases! Please review the changelog for additional details. Table of Contents Version 0.x How to install #How to install TODO: \u2026incomplete, please review documentation at a later point","tags":"","url":"current\/index.html"},{"title":"Release Notes","text":"#Release Notes Table of Contents Release Notes Support Policy v0.x Highlights \u201cMini\u201d Testing Framework Git Version Cache Changelog #Support Policy The following shows the supported versions of the \u201cCMake Scripts\u201d project. Version CMake Release Security Fixes Until 1.x 3.30 - ? TBD TBD 0.x* 3.30 - ? TBD N\/A * - current supported version. TBD - \u201cTo be decided\u201d. N\/A - \u201cNot available\u201d. #v0.x Highlights #\u201cMini\u201d Testing Framework (available since v0.1) A \u201cmini\u201d testing framework for testing your CMake modules and scripts. define_test(\"has built assets\" \"has_built_assets\") function(has_built_assets) assert_file_exists(\"resources\/images\/menu_bg.png\" MESSAGE \"No menu bg\") assert_file_exists(\"resources\/images\/bg.png\" MESSAGE \"No background\") # ...etc endfunction() See testing module for additional information. #Git (available since v0.1) Git related utilities. git_find_version_tag( OUTPUT version WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} ) message(\"${version}\") # 1.15.2 See git module for additional information. #Version (available since v0.1) Helpers for dealing with a project\u2019s versioning version_from_file( FILE \"version\" OUTPUT my_package ) message(\"${my_package}_SEMVER\") # 2.0.0-beta.3+AF1004 See version module for additional information. #Cache (available since v0.1) Module that offers additional caching functionality (via CMake\u2019s Cache Entry mechanism). cache_set( KEY foo VALUE \"bar\" TTL 5 ) # ... Elsewhere in your cmake scripts, 5 seconds later... cache_get(KEY foo) message(\"${foo}\") # (empty string) See cache module for additional information. #Changelog For additional information about the latest release, new features, changes or defect fixes, please review the Changelog.","tags":"","url":"current\/release_notes.html"},{"title":"Upgrade Guide","text":"#Upgrade Guide There is no upgrade guide for this version! #Onward Additional details can be found in the changelog","tags":"","url":"current\/upgrade_guide.html"},{"title":"Contribution Guide","text":"#Contribution Guide We appreciate all the help that we can get to improve this project. In this section, you will find useful information on how you can contribute. Table of Contents Contribution Guide Bug Report Security Vulnerability Feature Request Pull Requests #Bug Report If you have encountered a bug, feel free to report it. When reporting the bug, please consider the following: Where is the defect located? A good, short and precise description of the defect (Why is it a defect?) How can the defect be replicated? (A possible solution for how to resolve the defect) Once we have received the bug or defect report, we will address it as reasonably as we can. #Security Vulnerability See the Security Policy for details. #Feature Request If you have an idea for a new feature or perhaps changing an existing one, please feel free to create a feature request. #Pull Requests If you are able to fix a bug or defect, or perhaps add new features, then you can send us a pull request. Please follow this guideline: Fork this project Create a new local branch for the given fix, addition or change Write your changes Create executable test-cases (prove that your changes are solid!) Commit and push your changes to your fork Send a pull-request with your changes (please ensure to check \u201cAllow edits from maintainers\u201d) We will review your pull request, as soon as time permits. If your changes are accepted, then they will be merged into this project and released in an upcoming version. Should your pull request not be accepted, then you will be informed about it.","tags":"","url":"current\/contribution_guide.html"},{"title":"Security Policy","text":"#Security Policy Warning Please do NOT disclose security related issues publicly! Use GitHub\u2019s \u201cSecurity Advisories &gt; Report Vulnerability\u201d mechanism instead. For additional details, please read the \u201cHow to report a vulnerability\u201d for instructions. Table of Contents Security Policy How to report a vulnerability Supported Versions #How to report a vulnerability To report a security related issue, please use GitHub\u2019s vulnerability reporting mechanism. Follow the on-screen instructions. Report new Vulnerability For additional help, please consider reading \u201cBest practices for writing repository security advisories\u201c. Once we have received the security related issue, we will address it to the best of our ability, as soon as possible. #Supported Versions Please review the Support Policy before reporting security related issues.","tags":"","url":"current\/security_policy.html"},{"title":"Code of Conduct","text":"#Code of Conduct The following constitutes the code of conduct for the \u201cCMake Scripts\u201d project. Participants must be helpful and constructive. Participants must be tolerant and respectful towards the opinions of other participants. Participants must ensure their conduct is free from harassment, harmful deeds, inappropriate language or behaviour, and malicious intent. Efforts towards the benefit of the overall community must always be favoured, rather than individual needs. #Consequences Participants are subject to reasonable consequences, if the code of conduct is not upheld. Such consequences can include banning from further participation. #Reporting Any violations of the code of conduct can be reported to RSP Systems.","tags":"","url":"current\/code_of_conduct.html"},{"title":"Modules","text":"#Modules In here, you will find documentation for the available cmake modules.","tags":"","url":"current\/modules\/index.html"},{"title":"Cache","text":"#Cache The cache module offers additional functionality for CMake\u2019s Cache Entry mechanism. #How to include include(\"rsp\/cache\")","tags":"","url":"current\/modules\/cache\/index.html"},{"title":"Set","text":"#Set Use cache_set() to cache a variable. The function accepts the following parameters: KEY: The variable to assign and cache. VALUE: Value to assign and cache. TTL: (optional), Time-To-Live of cache entry in seconds (see TTL for details). TYPE: (optional), Cmake cache entry type, BOOL, STRING,\u2026etc. Defaults to STRING if not specified. DESCRIPTION: (optional), Description of cache entry. Caution Invoking the cache_set() function, is the equivalent to using CMake\u2019s set(... CACHE FORCE). Example cache_set( KEY foo VALUE \"bar\" ) message(\"${foo}\") # bar #TTL You can optionally specify a time-to-live (ttl) duration (in seconds), for the cache entry. Whenever the cached variable is queried (via has or get), the entry will automatically be removed, if it has expired. cache_set( KEY foo VALUE \"bar\" TTL 5 ) # ... Elsewhere in your cmake scripts, 5 seconds later... cache_get(KEY foo) message(\"${foo}\") # (empty string)","tags":"","url":"current\/modules\/cache\/set.html"},{"title":"Get","text":"#Get You can use the cache_get() function to retrieve a cached variable. It accepts the following parameters: KEY: The variable to assign resulting value to. DEFAULT: (optional), Default value to assign, if no cache entry found. Example cache_get( KEY perform_cleanup DEFAULT \"false\" ) if(perform_cleanup) # ...not shown... endif () #Expired Entries The benefit of using this function to retrieve a cached variable, is that it will automatically detect if the cached entry has expired. If this is the case, then the expired variable will be deleted. If a DEFAULT parameter has been specified, then that value is returned instead of an empty string. cache_set( KEY perform_cleanup VALUE \"true\" TYPE \"BOOL\" TTL 60 ) # ... Elsewhere in your cmake scripts, 60 seconds later... cache_get( KEY perform_cleanup DEFAULT \"false\" ) if(perform_cleanup) # ...not shown... endif ()","tags":"","url":"current\/modules\/cache\/get.html"},{"title":"Has","text":"#Has Use cache_has() to determine if a cached variable exists. It accepts the following parameters: KEY: The target variable to determine if it exists. OUTPUT: Output variable to assign the result to. Example cache_has( KEY build_assets OUTPUT exists ) if(exists) # ...not shown... endif () #Expired Entries Just like cache_get(), the cache_has() function respects the expiration status of a cached variable. If the queried variable has expired, then this function will assign false to the OUTPUT variable.","tags":"","url":"current\/modules\/cache\/has.html"},{"title":"Remember","text":"#Remember cache_remember() is responsible for retrieve cached entry if it exists, or invoke callback and cache resulting output value of the callback. The following parameters are accepted: KEY: _ The variable to assign and cache._ CALLBACK: _ The function or macro that returns value to be cached, if KEY hasn\u2019t already been cached._ TTL: (optional), Time-To-Live of cache entry in seconds (see TTL for details). TYPE: (optional), Cmake cache entry type, BOOL, STRING,\u2026etc. Defaults to STRING if not specified. DESCRIPTION: (optional), Description of cache entry. Example function(make_asset_uuid output) # ...complex logic for generating a UUID... (not shown here)... set(\"${output}\" \"...\") # Assign to \"output\" variable return(PROPAGATE \"${output}\") endfunction() cache_remember( KEY assert_uuid CALLBACK \"make_asset_uuid\" ) message(\"${assert_uuid}\") # E.g. 2786d7fb-6d88-4878-b1f6-4c66cee31700","tags":"","url":"current\/modules\/cache\/remember.html"},{"title":"Forget","text":"#Forget Call cache_forget() to delete a cached entry. It accepts the following parameters: KEY: The target variable to determine if it exists. OUTPUT: (optional), Variable to assign delete status. Example cache_forget( KEY run_cleanup OUTPUT was_deleted ) if(was_deleted) # ...not shown... endif ()","tags":"","url":"current\/modules\/cache\/forget.html"},{"title":"Git","text":"#Git This module contains helpers and utilities for interacting with git. #Requirements This module requires git to be available on your system. #How to include include(\"rsp\/git\")","tags":"","url":"current\/modules\/git\/index.html"},{"title":"Find Version Tag","text":"#Find Version Tag The git_find_version_tag() function allows you to find the nearest version tag that matches a version-pattern (local repository). Behind the scene, git-describe is invoked. Table of Contents Find Version Tag Example Match Pattern Default Version Exit on Failure #Example include(\"rsp\/git\") git_find_version_tag( OUTPUT version WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} ) message(\"${version}\") # 1.15.2 #Match Pattern By default, the following glob-pattern is used for matching a version tag: *[0-9].*[0-9].*[0-9]* To customize the pattern, specify the MATCH_PATTERN parameter. git_find_version_tag( OUTPUT pre_release WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} MATCH_PATTERN \"*[0-9].*[0-9].*[0-9]-*\" ) message(\"${pre_release}\") # 1.0.0-alpha.2 #Default Version If unable to find a version tag, &quot;0.0.0&quot; is returned (See also Exit on Failure). You can change this by setting the DEFAULT parameter, in situations when no version tag can be found. git_find_version_tag( OUTPUT version WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} DEFAULT \"0.1.0\" ) message(\"${version}\") # 0.1.0 #Exit on Failure A fatal error will be raised, if the EXIT_ON_FAILURE option is set, and no version tag can be found. When doing so, the default version parameter will be ignored. git_find_version_tag( OUTPUT version WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} DEFAULT \"0.1.0\" EXIT_ON_FAILURE ) # Fatal Error: No version tag found ...","tags":"","url":"current\/modules\/git\/find_version_tag.html"},{"title":"Helpers","text":"#Helpers The helpers module contains miscellaneous functions that are used by \u201cCMake Scripts\u201d. Feel free to use them within your own project, if you find them helpful. #How to include include(\"rsp\/helpers\")","tags":"","url":"current\/modules\/helpers\/index.html"},{"title":"Testing","text":"#Testing \u201cCMake Scripts\u201d has been developed with testing in mind. To ensure that the provided functionality works as intended, we have made an effort to write code that is testable. As a direct result of this, various testing utilities have been developed (e.g. for cmake modules and scripts), which are offered in this module. #How to include include(\"rsp\/testing\")","tags":"","url":"current\/modules\/testing\/index.html"},{"title":"Modules & Scripts","text":"#Testing CMake Modules &amp; Scripts The testing module includes a \u201cmini\u201d framework for testing your CMake modules and scripts. It is built on top of CTest. Table of Contents Testing CMake Modules &amp; Scripts Getting Started Directory Structure Define Test Suite Define Test Case Define Test(s) Build &amp; Run Caveats #Getting Started The following guide illustrates how you can get started. It is by no means a comprehensive guide on how to write tests, but rather just a starting point. #Directory Structure Create an appropriate directory in which your tests should reside. For instance, this can be located in the root of your project. You can name it \u201ctests\u201d, or whatever makes the most sense for you. The important part is to isolate tests from the remaining of your project\u2019s CMake logic. The following example is a possible directory and files structure, that you can use. \/tests \/unit \/assets build_assets_test.cmake CMakeLists.txt CMakeLists.txt #Define Test Suite In your \/tests\/CMakeLists.txt, define the test suite(s) for your project. # ...in your \/tests\/CMakeLists.txt enable_testing() project(my_package_tests LANGUAGES NONE) include(\"rsp\/testing\") # Define the test suites for this project define_test_suite(\"unit\" DIRECTORY \"${CMAKE_CURRENT_SOURCE_DIR}\/unit\") #Define Test Case To define a new test case, invoke the define_test_case() function. This should be done in each test file (e.g. in the \/tests\/unit\/assets\/build_assets_tests.cmake from the above shown example directory and files structure). # ... in your test file include(\"rsp\/testing\") define_test_case( \"Build Assets Test\" LABELS \"assets;build\" ) # ... remaining not shown ... #Define Test(s) Once your test-case has been defined, you can define the tests. To do so, you need to define the function that must be invoked when the test-case is executed. This is done by the define_test() function. # ... in your test file # ... previous not shown ... define_test(\"can build assets\" \"can_build_assets\") function(can_build_assets) # ... testing logic not shown ... assert_truthy(assets_built MESSAGE \"Assets could bot be built...\") endfunction() define_test(\"fails if assets not ready\" \"fails_when_not_ready\" EXPECT_FAILURE) function(fails_when_not_ready) # ... testing logic not shown ... assert_truthy(false MESSAGE \"Assets should not be built when not ready...\") endfunction() # ... etc #Build &amp; Run To run the tests, you must first build the project using CMake. After that, use CTests to run the tests. ctest --output-on-failure --parallel --test-dir &lt;your-build-directory&gt;\/tests #Caveats Due to the nature of how tests are defined (via ctest), and how this \u201cmini\u201d testing framework has been designed, you might be required to rebuild your CMake, whenever changes are made to the various \u201cdefine\u201d functions\u2019 parameters. This can, for instance, be when you rename a test function. Throughout the remain of this documentation, if a \u201cdefine\u201d function requires rebuilding before changes take effect, then it will be highlighted via a warning, similar to the one shown below: Rebuild Required Changes to function xyz parameters requires you to rebuild your project, before the changes take effect.","tags":"","url":"current\/modules\/testing\/cmake\/index.html"},{"title":"Test Suite","text":"#Test Suite The define_test_suite() function is used to group related test cases into a test suite. Table of Contents Test Suite Parameters Example Match Pattern Labels #Parameters The following parameters are accepted: &lt; name &gt;: Human readable name of test suite. The parameter is also used to label tests (see labels). DIRECTORY: Path to directory that contains test-cases. MATCH: (optional), Glob pattern used to match test-case files. Defaults to *_test.cmake (see match pattern). Rebuild Required Changes to function define_test_suite() parameters requires you to rebuild your project, before the changes take effect. #Example include(\"rsp\/testing\") define_test_suite(\"unit\" DIRECTORY \"${CMAKE_CURRENT_SOURCE_DIR}\/unit\") define_test_suite(\"integration\" DIRECTORY \"${CMAKE_CURRENT_SOURCE_DIR}\/integration\") Given the above shown example, when define_test_suite() is invoked, it will recursively search for files\u00b9 in the specified directory. Each file is then included into the current CMake scope. This means that calls to define_test_case() and define_test() are registered (tests are added to ctest). After you have built your CMake project, you will be able to run the tests. ctest --output-on-failure --test-dir &lt;your-build-directory&gt;\/tests \u00b9: See match pattern. #Match Pattern By default, only files that match *_test.cmake will be processed by define_test_suite(). If this is not to your liking, then you can specify a custom match pattern: define_test_suite( \"unit\" DIRECTORY \"${CMAKE_CURRENT_SOURCE_DIR}\/unit\" MATCH \"*Test.cmake\" ) #Labels The &lt; name &gt; parameter is used to automatically used as a label for all tests within the test suite. This allows you to use ctest\u2019s label regex functionality and thereby only run the tests from the suite that you wish. ctest --output-on-failure \\ --label-regex \"integration\" \\ --test-dir &lt;your-build-directory&gt;\/tests","tags":"","url":"current\/modules\/testing\/cmake\/test_suite.html"},{"title":"Test Case","text":"#Test Case define_test_case() is used to describe a test-case. In this context, a test case can be interpreted as a collection or related tests. Table of Contents Test Case Parameters Example Labels Before \/ After Callbacks Run Serial Multiple Test-Cases in same file #Parameters The following parameters are accepted: &lt; name &gt;: Human readable name of test case. The parameter is also used as an affix for test names, in ctest. BEFORE: (optional), Command or macro to execute before each test in test-case (see Before \/ After Callbacks). AFTER: (optional), Command or macro to execute after each test in test-case (see Before \/ After Callbacks). LABELS: (optional), List of labels to associate subsequent tests with (see labels). RUN_SERIAL: (optional), Option that prevents test-case\u2019s tests from running in parallel with other tests. Rebuild Required Changes to function define_test_case() parameters requires you to rebuild your project, before the changes take effect. #Example # ...inside your test file... include(\"rsp\/testing\") define_test_case( \"Assets Test\" LABELS \"assets\" ) # ...tests not shown ... Once you have defined a test-case, in the beginning of your test file, then all subsequent test definitions will automatically be associated with that test-case. Caution You should avoid defining multiple test-cases in a single file, as it can lead to unexpected behaviour. See multiple test-cases in same file for details. #Labels The LABELS parameter allows you to specify a list of labels, which are then automatically associated with each test, in the test-case. This also enables you to use ctest\u2019s label regex functionality to limit the tests that you wish to run (see ctest run example in test-suite documentation). define_test_case( \"Assets Test\" LABELS \"assets;resources;build\" ) # ...tests not shown ... #Before \/ After Callbacks The BEFORE and AFTER parameters allow you to specify a function or macro that must be executed before or after each test. This can be useful in situations when your tests require setup and teardown logic. define_test_case( \"Assets Test\" BEFORE \"before_assets_test\" AFTER \"after_assets_test\" ) macro(before_assets_test) # ...your setup logic... set(OUTPUT_DIR \"${CMAKE_CURRENT_BINARY_DIR}\/output\" PARENT_SCOPE) # ...etc endmacro() function(after_assets_test) # ... cleanup not shown ... endfunction() # \"Before\" macro will be invoked before the test... define_test(\"can build assets\" \"can_build_assets\") function(can_build_assets) # ... not shown ... endfunction() # \"After\" function will be invoked after the above test... Tip Depending on the complexity of your before and after logic, you have to set the RUN_SERIAL, to avoid race-conditions when tests are executed in parallel. #Run Serial If you are executing tests in parallel, and you have complex setup and teardown logic that could lead to race conditions, then you SHOULD mark the test-case to execute its tests in serial, by setting the RUN_SERIAL option. define_test_case( \"Assets Test\" BEFORE \"before_assets_test\" AFTER \"after_assets_test\" RUN_SERIAL ) # ...remaining not shown... #Multiple Test-Cases in same file If you wish to define multiple test-cases in the same file, then you manually need to \u201cend\u201d each test-case, before defining a new test-case. # ...inside your test file... define_test_case( \"Test-Case A\" ) # ...tests not shown ... # End \/ Close \"Test-Case A\" end_test_case() define_test_case( \"Test-Case B\" ) # ...tests not shown ... # End \/ Close \"Test-Case B\" end_test_case() Normally, define_test_suite() automatically ensures to \u201cend\u201d test-cases. However, it presumes that each test file only defines a single test-case. Please review the source code for additional information.","tags":"","url":"current\/modules\/testing\/cmake\/test_case.html"},{"title":"Test","text":"#Test The define_test() function is used to describe what callback (function) must be invoked when tests are executed. Behind the scene, this function is responsible to register the test for ctest. This is done by adding a ctest that invokes an \u201cintermediary\u201d - a test executor - which is responsible for invoking the specified callback, via define_test(). Table of Contents Test Parameters Example Failure Expectations Data Providers Skipping tests #Parameters &lt; name &gt;: Human readable name of test case. &lt; callback &gt;: The function that contains the actual test logic. DATA_PROVIDER: (optional), Command or macro that provides data-set(s) for the test. See data providers for details. EXPECT_FAILURE: (optional), Options, if specified then callback is expected to fail. See failure expectations for details. SKIP: (optional), Option, if set then test will be marked as \u201cdisabled\u201d and not executed. See skipping tests for details. Rebuild Required Changes to function define_test() parameters requires you to rebuild your project, before the changes take effect. Caution Although the &lt; callback &gt; parameter can accept a marco, you SHOULD always use a function for defining the actual test logic. Using a marco can lead to undesired side effects. Please read CMake\u2019s \u201cMacro vs. Function\u201c for additional details. #Example include(\"rsp\/testing\") # ... previous not shown ... define_test(\"assets are ready after build\" \"asserts_ready\") function(asserts_ready) # ...actual test logic not shown here... assert_truthy(assets_exist MESSAGE \"Assets have not been built...\") endfunction() #Failure Expectations When you need to test logic that is intended to fail when certain conditions are true, then you can mark your test to expect a failure. This is done by setting the EXPECT_FAILURE option. define_test(\"fails when assets not built\" \"fails_when_not_ready\" EXPECT_FAILURE) function(fails_when_not_ready) # ...actual test logic not shown here... assert_truthy(false) endfunction() Behind the scene, ctest\u2019s WILL_FAIL property is set for the given test, when the EXPECT_FAILURE option is set. #Data Providers You can specify a function or marco as a test\u2019s data-provider, via the DATA_PROVIDER parameter. Doing so will result in the same test being executed multiple times, with different sets of data. The specified function or marco MUST assign a list of \u201citems\u201d (test data) to the given &lt; output &gt; variable. function(provides_data output) set(\"${output}\" \"a;b;c;d\") return (PROPAGATE \"${output}\") endfunction() define_test( \"My Test\" \"my_test\" DATA_PROVIDER \"provides_data\" ) function(my_test letter) string(LENGTH \"${letter}\" length) assert_greater_than(0 length MESSAGE \"No letter provided: (length: ${length})\") endfunction() In the above \u201cMy Test\u201d will be registered multiple times, one for each item provided by the provides_data() function. Each data-set item is then passed on to the test, as an argument. Rebuild Required Whenever you change the items provided by a \u201cdata provider\u201d function, you will be required to rebuild your CMake project, before the changes are reflected by the executed tests! #Skipping tests Set the SKIP option, if you wish to ensure that a test is not executed by ctest. # Test is SKIPPED define_test(\"can build with bitmap pictures\" \"can_build_with_bitmap\" SKIP) function(can_build_with_bitmap) # ...not shown... endfunction() Behind the scene, ctest\u2019s DISABLED property is set, when a test is marked as skipped.","tags":"","url":"current\/modules\/testing\/cmake\/test.html"},{"title":"Run Tests","text":"#Run Tests To run test tests, you must first ensure that you build your CMake project. Once you have done so, use the ctest executable to execute the tests. ctest --output-on-failure --test-dir &lt;your-build-directory&gt;\/tests #Run Specific Tests To run only certain tests, use the --label-regex option. ctest --output-on-failure \\ --label-regex \"unit\" \\ --test-dir &lt;your-build-directory&gt;\/tests For additional information, see \u201clabels\u201d section in test suites and test cases. #Run Parallel To run tests in parallel, use the --parallel option. ctest --output-on-failure --parallel --test-dir &lt;your-build-directory&gt;\/tests #Run Failed To (re)run tests that have failed, use the --rerun-failed option. ctest --rerun-failed --test-dir &lt;your-build-directory&gt;\/tests #Onward For additional command line arguments and options, please review the official documentation for the ctest executable.","tags":"","url":"current\/modules\/testing\/cmake\/run_tests.html"},{"title":"Executor","text":"#Test Executor When tests are registered (via ctest\u2019s add_test()), a \u201ctest executor\u201d (cmake script) is requested executed. The executor is then responsible for invoking the actual test callback, that has been specified via define_test(). In addition, the executor is also responsible for executing eventual before and after callbacks, for the test case. #Location The executor can be found at: rsp\/testing\/executor.cmake. #Custom Executor To use a custom executor, set the path to your executor via the RSP_TEST_EXECUTOR_PATH property. This SHOULD be done before specifying your test suites. # ...in your \/tests\/CMakeLists.txt enable_testing() project(my_package_tests LANGUAGES NONE) include(\"rsp\/testing\") # Set path to custom test executor set(RSP_TEST_EXECUTOR_PATH \"..\/cmake\/my_custom_test_executor.cmake\") define_test_suite(\"unit\" DIRECTORY \"${CMAKE_CURRENT_SOURCE_DIR}\/unit\")","tags":"","url":"current\/modules\/testing\/cmake\/executor.html"},{"title":"Asserts","text":"#Asserts Table of Contents Asserts Failure Message Existence assert_defined() assert_not_defined() Boolean assert_truthy() assert_falsy() Numbers assert_equals() assert_not_equals() assert_less_than() assert_less_than_or_equal() assert_greater_than() assert_greater_than_or_equal() Strings assert_string_equals() assert_string_not_equals() assert_string_empty() assert_string_not_empty() Lists assert_in_list() assert_not_in_list() Commands &amp; Macros assert_is_callable() assert_is_not_callable() Files &amp; Paths assert_file_exists() assert_file_not_exists() #Failure Message All assert functions support an optional MESSAGE argument, which is shown if the assertion failed. assert_truthy(false MESSAGE \"My fail msg...\") #Existence #assert_defined() Assert key to be defined. assert_defined(my_variable) See https:\/\/cmake.org\/cmake\/help\/latest\/command\/if.html#defined. #assert_not_defined() The opposite of assert_defined(). assert_not_defined(my_variable) #Boolean #assert_truthy() Assert key to be truthy. assert_truthy(my_variable) See https:\/\/cmake.org\/cmake\/help\/latest\/command\/if.html#basic-expressions. #assert_falsy() The opposite of assert_truthy(). assert_falsy(my_variable) #Numbers #assert_equals() Assert numeric keys or values equal each other.. assert_equals(expected actual) See https:\/\/cmake.org\/cmake\/help\/latest\/command\/if.html#equal. #assert_not_equals() The opposite of assert_equals(). assert_not_equals(expected actual) #assert_less_than() Assert numeric key or value is less than specified value. assert_less_than(expected actual) See https:\/\/cmake.org\/cmake\/help\/latest\/command\/if.html#less. #assert_less_than_or_equal() Assert numeric key or value is less than or equal to the specified value. assert_less_than_or_equal(expected actual) See https:\/\/cmake.org\/cmake\/help\/latest\/command\/if.html#less-equal. #assert_greater_than() Assert numeric key or value is greater than specified value. assert_greater_than(expected actual) See https:\/\/cmake.org\/cmake\/help\/latest\/command\/if.html#greater. #assert_greater_than_or_equal() Assert numeric key or value is greater than or equal to the specified value. assert_greater_than_or_equal(expected actual) See https:\/\/cmake.org\/cmake\/help\/latest\/command\/if.html#greater-equal. #Strings #assert_string_equals() Assert string keys or values equal each other. assert_string_equals(expected actual) See https:\/\/cmake.org\/cmake\/help\/latest\/command\/if.html#strequal #assert_string_not_equals() Opposite of assert_string_equals(). assert_string_not_equals(expected actual) #assert_string_empty() Assert given string is empty. assert_string_empty(\"${my_string}\") See https:\/\/cmake.org\/cmake\/help\/latest\/command\/string.html#length #assert_string_not_empty() Opposite of assert_string_empty(). assert_string_not_empty(\"${my_string}\") #Lists #assert_in_list() Assert key (value) to be in given list. assert_in_list(item list) See https:\/\/cmake.org\/cmake\/help\/latest\/command\/if.html#in-list. #assert_not_in_list() Opposite of assert_in_list(). assert_not_in_list(item list) #Commands &amp; Macros #assert_is_callable() Assert key to be a callable command or macro. assert_is_callable(\"my_function\") See https:\/\/cmake.org\/cmake\/help\/latest\/command\/if.html#command. #assert_is_not_callable() Opposite of assert_is_callable(). assert_is_not_callable(\"my_unknown_function\") #Files &amp; Paths #assert_file_exists() Assert file exists. assert_file_exists(\"${my_file_path}\") See https:\/\/cmake.org\/cmake\/help\/latest\/command\/if.html#exists. #assert_file_not_exists() Opposite of assert_file_exists(). assert_file_not_exists(\"${my_file_path}\")","tags":"","url":"current\/modules\/testing\/cmake\/asserts.html"},{"title":"Version","text":"#Version This module contains helpers for dealing with a project\u2019s versioning. #Requirements The same requirements as for the git module. #How to include include(\"rsp\/version\")","tags":"","url":"current\/modules\/version\/index.html"},{"title":"Semantic Version","text":"#Semantic Version Functions and macros that are prefixed semver_* offer help to work with version strings, in accordance with Semantic Version.","tags":"","url":"current\/modules\/version\/semver\/index.html"},{"title":"Parse","text":"#Parse Semantic Version semver_parse() parses a semantic version string and assigns the various version parts to the provided output variable. Table of Contents Parse Semantic Version Example Output Full Version Major, Minor and Patch Semantic Version Major Version Minor Version Patch Version Pre-Release Build Metadata Invalid Version #Example include(\"rsp\/version\") semver_parse( VERSION \"v2.0.0-beta.3+AF1004\" OUTPUT my_package ) # (see example output below...) #Output #Full Version The [OUTPUT] variable will contain the full version string, as it was provided: message(\"${my_package}\") # v2.0.0-beta.3+AF1004 #Major, Minor and Patch The [OUTPUT]_VERSION variable contains a CMake friendly version string (major.minor.patch) message(\"${my_package}_VERSION\") # 2.0.0 #Semantic Version The [OUTPUT]_SEMVER variable contains the full semantic version, without eventual \u201cv\u201d prefix. message(\"${my_package}_SEMVER\") # 2.0.0-beta.3+AF1004 #Major Version The [OUTPUT]_MAJOR variable contains the major version. message(\"${my_package}_MAJOR\") # 2 #Minor Version The [OUTPUT]_MINOR variable contains the minor version. message(\"${my_package}_MINOR\") # 0 #Patch Version The [OUTPUT]_PATCH variable contains the patch version. message(\"${my_package}_PATCH\") # 0 #Pre-Release The [OUTPUT]_PRE_RELEASE variable contains the pre-release version. message(\"${my_package}_PRE_RELEASE\") # beta.3 #Build Metadata The [OUTPUT]_BUILD_METADATA variable contains the build metadata. message(\"${my_package}_BUILD_METADATA\") # AF1004 #Invalid Version A fatal error is raised, in situations when the provided version string cannot be parsed in accordance with Semantic Version. semver_parse( VERSION \"4.11\" OUTPUT my_package ) # Fatal Error: 4.11 is not a valid semantic version","tags":"","url":"current\/modules\/version\/semver\/parse.html"},{"title":"Version File","text":"#Version File(s) In this section you can find examples on how to read and write a version string, from and to a file. Table of Contents Version File(s) Write Version File Read Version File Exit on Failure #Write Version File Use write_version_file() to write a version string to a specified file. The function accepts two parameters: FILE: Path to target file in which the version must be written VERSION: (optional) The version string to write in file (see \u201cdefault version\u201d for details). Example include(\"rsp\/version\") write_version_file( FILE \"version.txt\" VERSION \"v1.4.3\" ) Caution write_version_file() expects the VERSION parameter to be a valid version string that can be parsed by semver_parse(). A fatal error is raised, if that is not the case. Default Version If the VERSION parameter is not specified, then git_find_version_tag() is used to obtain the nearest version tag. This will then be written to the target version file. #Read Version File The version_from_file() can be used to read a version string from a specified file. Once a version string has been obtained, it will be parsed using semver_parse. Example include(\"rsp\/version\") version_from_file( FILE \"version.txt\" OUTPUT my_package ) message(\"${my_package}_SEMVER\") # 2.0.0-beta.3+AF1004 message(\"${my_package}_VERSION\") # 2.0.0 Caution Just like the write_version_file() function, the version_from_file() also parses the version string using semver_parse(). A fatal error is raised, if the version string is not valid. Default Version If the given file does not contain a version string, then &quot;0.0.0&quot; is returned. To change this behaviour, specify the DEFAULT parameter. version_from_file( FILE \"version.txt\" OUTPUT my_package DEFAULT \"1.0.0\" ) message(\"${my_package}_VERSION\") # 1.0.0 #Exit on Failure When the EXIT_ON_FAILURE option is set, the function will raise a fatal error in the following situations: If the version file does not exist. If obtained version string cannot be parsed. The DEFAULT parameter will be ignored, if this option is set. version_from_file( FILE \"unknown-file\" OUTPUT my_package DEFAULT \"1.0.0\" EXIT_ON_FAILURE ) # Fatal Error: Version file unknown-file does not exist","tags":"","url":"current\/modules\/version\/version_file.html"},{"title":"CMake Scripts","text":"#About The CMake Scripts package contains a collection of reusable \u201cmodules\u201d, that can be used in your CMakeLists.txt, for your C++ projects. #Authors \u201cCMake Scripts\u201d is developed and maintained by RSP System A\/S.","tags":"","url":"index.html"},{"title":"Archive","text":"#Archive The archive contains documentation for previous released versions, as well as for the upcoming major version (when available).","tags":"","url":"archive\/index.html"},{"title":"next","text":"#Not Available The next version of \u201cCMake Scripts\u201d has yet to be designed and implemented. Please come back at a later time to review the documentation\u2026","tags":"","url":"archive\/v_next\/index.html"}]});