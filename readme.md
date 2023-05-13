# display-boxes



## Description

Bash function or script to display nice-looking boxes around your content like:

<img src="img/display-box-type-1.png" style="align: left; margin-bottom: 10px;">

The function will automatically determine the length of each column and draw the box appropriately. It accepts two multi-line strings which have any single-character delimiter to separate columns or 2+ spaces.


## Input

### $headers

The first contains the header data with tabs separating out the columns.

### $body

The second contains the body data which is typically a multi-line string with tabs separating the columns.

### $style

The `-s` argument is optional and can be used to set the [box style](#box-styles). Default is 1.

### $padding

The `-p` argument is optional and can be passed in to alter the padding left and right of the data. Default is 1.

### $delimiter

The `-d` argument is optional and can be passed in to specify the data delimiter if it is not a tab or 2+ spaces.


### Compatibility

It is recommended you use the argument prefixes to call these, but they are optional for backwards compatibility. The old syntax of: `display-box "$headers" "$body" 4 2` is still valid.


### Inline Script Option

Also included is a script that will read in stdin and call the display-box function dynamically. This is useful for piping in your content directly. It does still allowing you to pass in arguments to modify the settings.

The syntax of this inline example is:
```
echo "$multi_line_string" | /path/to/display-box.sh -s 2 -p 2 -d ,
```

## Usage

### Quick example

<img src="img/display-boxes-usage.png" style="align: left; margin-bottom: 10px;">



Deeper dive walk-through of each section:

### Step 1)

Include the function

<img src="img/display-boxes-usage-step1.png" style="align: left; margin-bottom: 10px;">



### Step 2)

Create two strings that are tab-separated

<img src="img/display-boxes-usage-step2.png" style="align: left; margin-bottom: 10px;">



### Step 3)

Optionally define the [box style](#box-styles) and the padding

<img src="img/display-boxes-usage-step3.png" style="align: left; margin-bottom: 10px;">



### Step 4)

Call the display-box function passing in the required $headers and $body variables. Other optional variables are Box Style and Padding

<img src="img/display-boxes-usage-step4.png" style="align: left; margin-bottom: 10px;">

<a name="box-styles"></a>

## Box Styles

There are several different box styles you can choose between



### Type 1 - Single-bars

<img src="img/display-box-type-1.png" style="align: left; margin-bottom: 10px;">




### Type 2 - Double-bars

<img src="img/display-box-type-2.png" style="align: left; margin-bottom: 10px;">




### Type 3 - Double-outer, single-inner

<img src="img/display-box-type-3.png" style="align: left; margin-bottom: 10px;">




### Type 4 - Double-bars without side walls

<img src="img/display-box-type-4.png" style="align: left; margin-bottom: 10px;">




### Type 5 - Double Bars on top and bottom without side walls

<img src="img/display-box-type-5.png" style="align: left; margin-bottom: 10px;">




### Type 6 - Minimal

<img src="img/display-box-type-6.png" style="align: left; margin-bottom: 10px;">



## Examples

There are two example scripts included in the `examples` directory. The `examples/example-all.sh` script will display the example in all available styles.

There is also an inline example in `examples/example-inline.sh` which shows how to pipe in your content.



## Future enhancements under consideration

1. Add Colors (borders, background, separate for header/body)
2. Option to add drop-shadow
3. Separate padding-left from padding-right
4. Possibly add different padding for header vs body
5. Option to add bars between each line in body (like Excel)
6. Add style for solid block bars (https://en.wikipedia.org/wiki/Block_Elements)
7. Add style with double-bars for header and single bars for body
8. Add style with double-bars for header and outside but single bars for body columns
9. Add style with only horizontal bars
10. Option to add margin between columns (as opposed to padding) for styles without vertical bars



## Versions

| Version Number | Date Released | Description of changes                          |
| -------------- | ------------- | ----------------------------------------------- |
| v1.0           | 30 Apr 2020   | Initial version                                 |
| v1.0.1         | 22 Mar 2022   | Minor bug fix                                   |
| v1.1           | 13 May 2023   | Added custom delimiter and inline functionality |
