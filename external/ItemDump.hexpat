#pragma loop_limit 99999
import std.mem;
struct tag {
    u8 tagnamesize;
    char tagname[tagnamesize];
};
struct taglib {
    u8 tagcount;
    tag tags[tagcount];
};
struct itemdump {
    u8 namesize;
    char name[namesize];
    taglib tags;
};
itemdump itm[100] @$;