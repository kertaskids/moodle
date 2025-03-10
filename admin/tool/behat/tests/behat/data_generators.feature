@tool @tool_behat @javascript
Feature: Set up contextual data for tests
  In order to write tests quickly
  As a developer
  I need to fill the database with fixtures

  Scenario: Add a bunch of users
    Given the following "users" exist:
      | username  | password  | firstname | lastname |
      | testuser  | testuser  |  |  |
      | testuser2 | testuser2 | TestFirstname | TestLastname |
    And I log in as "testuser"
    And I log out
    When I log in as "testuser2"
    Then I should see "TestFirstname"

  Scenario: Add a bunch of courses and categories
    Given the following "categories" exist:
      | name | category | idnumber |
      | Cat 1 | 0 | CAT1 |
      | Cat 2 | CAT1 | CAT2 |
      | Cat 3 | CAT1 | CAT3 |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | COURSE1 | CAT3 |
      | Course 2 | COURSE2 | CAT3 |
      | Course 3 | COURSE3 | 0 |
    When I log in as "admin"
    And I am on site homepage
    Then I should see "Course 1"
    And I should see "Course 2"
    And I should see "Course 3"
    And I go to the courses management page
    And I follow "Cat 1"
    And I should see "Cat 2"
    And I should see "Cat 3"
    And I follow "Cat 3"
    And I should see "Course 1"
    And I should see "Course 2"
    And I follow "Cat 2"
    And I should see "No courses in this category"
    And I follow "Category 1"
    And I should see "Course 3"

  Scenario: Add a bunch of groups and groupings
    Given the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1 |
    And the following "groups" exist:
      | name | course | idnumber |
      | Group 1 | C1 | G1 |
      | Group 2 | C1 | G2 |
    And the following "groupings" exist:
      | name | course | idnumber |
      | Grouping 1 | C1 | GG1 |
      | Grouping 2 | C1 | GG2 |
    When I log in as "admin"
    And I am on the "Course 1" "groups" page
    Then I should see "Group 1"
    And I should see "Group 2"
    And I set the field "Participants tertiary navigation" to "Groupings"
    And I should see "Grouping 1"
    And I should see "Grouping 2"

  Scenario: Role overrides
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher1@example.com |
      | student1 | Student | 1 | student1@example.com |
    And the following "categories" exist:
      | name | category | idnumber |
      | Cat 1 | 0 | CAT1 |
    And the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1 |
    And the following "course enrolments" exist:
      | user | course | role |
      | student1 | C1 | student |
      | teacher1 | C1 | editingteacher |
    And the following "permission overrides" exist:
      | capability | permission | role | contextlevel | reference |
      | mod/forum:editanypost | Allow | student | Course | C1 |
      | mod/forum:replynews | Prevent | editingteacher | Course | C1 |
    When I log in as "admin"
    And I am on the "Course 1" "permissions" page
    And I set the field "Advanced role override" to "Student (1)"
    Then "mod/forum:editanypost" capability has "Allow" permission
    And I press "Cancel"
    And I set the field "Advanced role override" to "Teacher (1)"
    And "mod/forum:replynews" capability has "Prevent" permission
    And I press "Cancel"

  Scenario: Add course enrolments
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | student1 | Student | 1 | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1 | topics |
    And the following "course enrolments" exist:
      | user | course | role |
      | student1 | C1 | student |
    When I am on the "Course 1" course page logged in as student1
    Then I should see "New section"

  Scenario: Add role assigns
    Given the following "roles" exist:
      | name                   | shortname | description      | archetype      |
      | Custom editing teacher | custom1   | My custom role 1 | editingteacher |
      | Custom student         | custom2   |                  |                |
    And the following "users" exist:
      | username | firstname | lastname | email |
      | user1 | User | 1 | user1@example.com |
      | user2 | User | 2 | user2@example.com |
      | user3 | User | 3 | user3@example.com |
      | user4 | User | 4 | user4@example.com |
      | user5 | User | 5 | user5@example.com |
    And the following "categories" exist:
      | name | category | idnumber |
      | Cat 1 | 0 | CAT1 |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1 | CAT1 |
    And the following "course enrolments" exist:
      | user | course | role |
      | user4 | C1 | custom1 |
      | user2 | C1 | student |
      | user3 | C1 | editingteacher |
    And the following "role assigns" exist:
      | user  | role           | contextlevel | reference |
      | user1 | manager        | System       |           |
      | user2 | editingteacher | Category     | CAT1      |
      | user5 | custom2        | System       |           |
    When I log in as "user1"
    And I am on site homepage
    Then edit mode should be available on the current page
    And I am on the "Course 1" course page logged in as user2
    Then edit mode should be available on the current page
    And I am on the "Course 1" course page logged in as user3
    Then edit mode should be available on the current page
    And I am on the "Course 1" course page logged in as user4
    Then edit mode should be available on the current page
    And I log out
    And I log in as "user5"
    And I should see "You are logged in as"
    And I am on "Course 1" course homepage
    And I should see "You cannot enrol yourself in this course."

  Scenario: Add modules
    Given the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1 |
    And the following "activities" exist:
      | activity   | name                   | intro                         | course | idnumber    |
      | assign     | Test assignment name   | Test assignment description   | C1     | assign1     |
      | book       | Test book name         | Test book description         | C1     | book1       |
      | choice     | Test choice name       | Test choice description       | C1     | choice1     |
      | data       | Test database name     | Test database description     | C1     | data1       |
      | feedback   | Test feedback name     | Test feedback description     | C1     | feedback1   |
      | folder     | Test folder name       | Test folder description       | C1     | folder1     |
      | forum      | Test forum name        | Test forum description        | C1     | forum1      |
      | glossary   | Test glossary name     | Test glossary description     | C1     | glossary1   |
      | imscp      | Test imscp name        | Test imscp description        | C1     | imscp1      |
      | label      | Test label name        | Test label description        | C1     | label1      |
      | lesson     | Test lesson name       | Test lesson description       | C1     | lesson1     |
      | lti        | Test lti name          | Test lti description          | C1     | lti1        |
      | page       | Test page name         | Test page description         | C1     | page1       |
      | quiz       | Test quiz name         | Test quiz description         | C1     | quiz1       |
      | resource   | Test resource name     | Test resource description     | C1     | resource1   |
      | scorm      | Test scorm name        | Test scorm description        | C1     | scorm1      |
      | url        | Test url name          | Test url description          | C1     | url1        |
      | wiki       | Test wiki name         | Test wiki description         | C1     | wiki1       |
      | workshop   | Test workshop name     | Test workshop description     | C1     | workshop1   |
    And the following "scales" exist:
      | name | scale |
      | Test Scale 1 | Disappointing, Good, Very good, Excellent |
    And the following "activities" exist:
      | activity   | name                            | intro                         | course | idnumber    | grade |
      | assign     | Test assignment name with scale | Test assignment description   | C1     | assign1     | Test Scale 1 |
    When I am on the "Course 1" course page logged in as admin
    Then I should see "Test assignment name"
    # Assignment 2.2 module type is disabled by default
    # And I should see "Test assignment22 name"
    And I should see "Test book name"
    And I should see "Test choice name"
    And I should see "Test database name"
    # Feedback module type is disabled by default
    # And I should see "Test feedback name"
    And I should see "Test folder name"
    And I should see "Test forum name"
    And I should see "Test glossary name"
    And I should see "Test imscp name"
    # We don't see label name, we see only description:
    And I should see "Test label description"
    And I should see "Test lesson name"
    And I should see "Test lti name"
    And I should see "Test page name"
    And I should see "Test quiz name"
    And I should see "Test resource name"
    And I should see "Test scorm name"
    And I should see "Test url name"
    And I should see "Test wiki name"
    And I should see "Test workshop name"
    And I follow "Test assignment name"
    And I should see "Test assignment description"
    And I am on "Course 1" course homepage
    And I follow "Test assignment name with scale"
    And I follow "Settings"
    And the field "Type" matches value "Scale"

  Scenario: Add relations between users and groups
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | student1 | Student | 1 | student1@example.com |
      | student2 | Student | 2 | student2@example.com |
    And the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1 |
    And the following "groups" exist:
      | name | course | idnumber |
      | Group 1 | C1 | G1 |
      | Group 2 | C1 | G2 |
    And the following "groupings" exist:
      | name | course | idnumber |
      | Grouping 1 | C1 | GG1 |
    And the following "course enrolments" exist:
      | user | course | role |
      | student1 | C1 | student |
      | student2 | C1 | student |
    And the following "group members" exist:
      | user | group |
      | student1 | G1 |
      | student2 | G2 |
    And the following "grouping groups" exist:
      | grouping | group |
      | GG1 | G1 |
    When I log in as "admin"
    And I am on the "Course 1" "groups" page
    Then the "groups" select box should contain "Group 1 (1)"
    And the "groups" select box should contain "Group 2 (1)"
    And I set the field "groups" to "Group 1 (1)"
    And the "members" select box should contain "Student 1 (student1@example.com)"
    And I set the field "groups" to "Group 2 (1)"
    And the "members" select box should contain "Student 2 (student2@example.com)"

  Scenario: Add cohorts and cohort members with data generator
    Given the following "categories" exist:
      | name  | category | idnumber |
      | Cat 1 | 0        | CAT1     |
    And the following "users" exist:
      | username | firstname | lastname | email |
      | student1 | Student | 1 | student1@example.com |
      | student2 | Student | 2 | student2@example.com |
    And the following "cohorts" exist:
      | name            | idnumber |
      | System cohort A | CHSA     |
    And the following "cohorts" exist:
      | name                 | idnumber | contextlevel | reference |
      | System cohort B      | CHSB     | System       |           |
      | Cohort in category   | CHC      | Category     | CAT1      |
      | Empty cohort         | CHE      | Category     | CAT1      |
    And the following "cohort members" exist:
      | user     | cohort |
      | student1 | CHSA   |
      | student2 | CHSB   |
      | student1 | CHSB   |
      | student1 | CHC    |
    When I log in as "admin"
    And I navigate to "Users > Accounts > Cohorts" in site administration
    Then the following should exist in the "reportbuilder-table" table:
      | Name            | Cohort size |
      | System cohort A | 1           |
      | System cohort B | 2           |
    And I should not see "Cohort in category"
    And I am on course index
    And I follow "Cat 1"
    And I navigate to "Cohorts" in current page administration
    And I should not see "System cohort"
    And the following should exist in the "reportbuilder-table" table:
      | Name               | Cohort size |
      | Cohort in category | 1           |
      | Empty cohort       | 0           |

  Scenario: Add grade categories with data generator
    Given the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1 |
    And the following "grade categories" exist:
      | fullname | course |
      | Grade category 1 | C1 |
    And the following "grade categories" exist:
      | fullname | course | gradecategory |
      | Grade sub category 2 | C1 | Grade category 1 |
    When I am on the "Course 1" "grades > Grader report > View" page logged in as "admin"
    Then I should see "Grade category 1"
    And I should see "Grade sub category 2"

  Scenario: Add a bunch of grade items
    Given the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1 |
    And the following "grade categories" exist:
      | fullname | course |
      | Grade category 1 | C1 |
    And the following "grade categories" exist:
      | fullname | course | gradecategory |
      | Grade sub category 2 | C1 | Grade category 1 |
    And the following "grade items" exist:
      | itemname    | course |
      | Test Grade Item 1 | C1 |
    And the following "grade items" exist:
      | itemname    | course | gradecategory |
      | Test Grade Item 2 | C1 | Grade category 1 |
      | Test Grade Item 3 | C1 | Grade sub category 2 |
    When I am on the "Course 1" "grades > gradebook setup" page logged in as "admin"
    Then I should see "Test Grade Item 1"
    And I click on grade item menu "Test Grade Item 1" of type "gradeitem" on "setup" page
    And I choose "Edit grade item" in the open action menu
    And I expand all fieldsets
    And I should see "Course 1"
    And I click on "Cancel" "button" in the "Edit grade item" "dialogue"
    And I should see "Grade category 1"
    And I should see "Test Grade Item 2"
    And I click on grade item menu "Test Grade Item 2" of type "gradeitem" on "setup" page
    And I choose "Edit grade item" in the open action menu
    And I expand all fieldsets
    And I should see "Grade category 1"
    And I click on "Cancel" "button" in the "Edit grade item" "dialogue"
    And I should see "Grade sub category 2"
    And I should see "Test Grade Item 3"
    And I click on grade item menu "Test Grade Item 3" of type "gradeitem" on "setup" page
    And I choose "Edit grade item" in the open action menu
    And I expand all fieldsets
    And I should see "Grade sub category 2"
    And I click on "Cancel" "button" in the "Edit grade item" "dialogue"

  Scenario: Add a bunch of scales
    Given the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1 |
    And the following "scales" exist:
      | name | scale |
      | Test Scale 1 | Disappointing, Good, Very good, Excellent |
    When I am on the "Course 1" "grades > scales" page logged in as admin
    Then I should see "Test Scale 1"
    And I should see "Disappointing,  Good,  Very good,  Excellent"

  Scenario: Add a bunch of outcomes
    Given the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "scales" exist:
      | name | scale |
      | Test Scale 1 | Disappointing, Good, Very good, Excellent |
    And the following "grade outcomes" exist:
      | fullname        | shortname | scale        |
      | Grade outcome 1 | OT1       | Test Scale 1 |
    And the following "grade outcomes" exist:
      | fullname        | shortname | course | scale        |
      | Grade outcome 2 | OT2       | C1     | Test Scale 1 |
    And the following config values are set as admin:
      | enableoutcomes | 1 |
    When I am on the "Course 1" "grades > outcomes" page logged in as admin
    Then I should see "Grade outcome 1" in the "#addoutcomes" "css_element"
    And I should see "Grade outcome 2" in the "#removeoutcomes" "css_element"
    And I press "Manage outcomes"
    And the following should exist in the "generaltable" table:
      | Full name       | Short name | Scale        |
      | Grade outcome 2 | OT2        | Test Scale 1 |

  Scenario: Add a bunch of outcome grade items
    Given the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "scales" exist:
      | name         | scale                                     |
      | Test Scale 1 | Disappointing, Good, Very good, Excellent |
    And the following "grade outcomes" exist:
      | fullname        | shortname | course | scale        |
      | Grade outcome 1 | OT1       | C1     | Test Scale 1 |
    And the following "grade categories" exist:
      | fullname         | course |
      | Grade category 1 | C1     |
    And the following "grade items" exist:
      | itemname                  | course | outcome | gradecategory    |
      | Test Outcome Grade Item 1 | C1     | OT1     | Grade category 1 |
    And the following config values are set as admin:
      | enableoutcomes | 1 |
    When I am on the "Course 1" "grades > gradebook setup" page logged in as "admin"
    Then I should see "Test Outcome Grade Item 1"
    And I click on grade item menu "Test Outcome Grade Item 1" of type "gradeitem" on "setup" page
    And I choose "Edit grade item" in the open action menu
    And I click on "Show more..." "link" in the "Edit outcome item" "dialogue"
    And the field "Outcome" matches value "Grade outcome 1"
    And I should see "Grade category 1" in the "Grade category" "form_row"
    And I press "Cancel"

  Scenario: Add a block
    Given the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "blocks" exist:
      | blockname    | contextlevel | reference | pagetypepattern | defaultregion |
      | online_users | Course       | C1        | course-view-*   | site-pre      |
    When I am on the "Course 1" course page logged in as admin
    Then I should see "Online users"
