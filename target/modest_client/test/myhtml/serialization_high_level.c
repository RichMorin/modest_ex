/*
 Copyright (C) 2015-2016 Alexander Borisov

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA

 Author: lex.borisov@gmail.com (Alexander Borisov)
*/

#include <stdio.h>
#include <stdlib.h>
#include <myhtml/api.h>

#include "example.h"

struct res_html {
    char  *html;
    size_t size;
};

struct res_html load_html_file(const char* filename)
{
    FILE *fh = fopen(filename, "rb");
    if(fh == NULL) {
        fprintf(stderr, "Can't open html file: %s\n", filename);
        exit(EXIT_FAILURE);
    }

    if(fseek(fh, 0L, SEEK_END) != 0) {
        fprintf(stderr, "Can't set position (fseek) in file: %s\n", filename);
        exit(EXIT_FAILURE);
    }

    long size = ftell(fh);

    if(fseek(fh, 0L, SEEK_SET) != 0) {
        fprintf(stderr, "Can't set position (fseek) in file: %s\n", filename);
        exit(EXIT_FAILURE);
    }

    if(size <= 0) {
        fprintf(stderr, "Can't get file size or file is empty: %s\n", filename);
        exit(EXIT_FAILURE);
    }

    char *html = (char*)malloc(size + 1);
    if(html == NULL) {
        fprintf(stderr, "Can't allocate mem for html file: %s\n", filename);
        exit(EXIT_FAILURE);
    }

    size_t nread = fread(html, 1, size, fh);
    if (nread != size) {
        fprintf(stderr, "could not read %ld bytes (" MyCORE_FMT_Z " bytes done)\n", size, nread);
        exit(EXIT_FAILURE);
    }

    fclose(fh);

    struct res_html res = {html, (size_t)size};
    return res;
}

int main(int argc, const char * argv[])
{
    const char* path = "../test/fixtures/test_page.html";

    // if (argc == 2) {
    //     path = argv[1];
    // }
    // else {
    //     printf("Bad ARGV!\nUse: serialization_high_level <path_to_html_file>\n");
    //     exit(EXIT_FAILURE);
    // }

    struct res_html res = load_html_file(path);

    // basic init
    myhtml_t* myhtml = myhtml_create();
    myhtml_init(myhtml, MyHTML_OPTIONS_DEFAULT, 1, 0);

    // init tree
    myhtml_tree_t* tree = myhtml_tree_create();
    myhtml_tree_init(tree, myhtml);

    // parse html
    myhtml_parse(tree, MyENCODING_UTF_8, res.html, res.size);

    mycore_string_raw_t str_raw;
    mycore_string_raw_clean_all(&str_raw);

    if(myhtml_serialization_tree_buffer(myhtml_tree_get_document(tree), &str_raw)) {
        fprintf(stderr, "Could not serialization for the tree\n");
        exit(EXIT_FAILURE);
    }

    printf("%s", str_raw.data);
    mycore_string_raw_destroy(&str_raw, false);

    // release resources
    myhtml_tree_destroy(tree);
    myhtml_destroy(myhtml);

    free(res.html);

    return 0;
}




