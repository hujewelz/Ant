//
//  cache.h
//  Ant
//
//  Created by huluobo on 2019/2/18.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#include <stdio.h>

typedef uint32_t mask_t;

struct bucket_t {
    const void *target;
    IMP imp;
};

typedef struct bucket_t *bucket;

struct cache_t {
    bucket *_buckets;
    mask_t _capacity;
    mask_t _occupied;
    
    const char *_name;
    void **_args;
    int _numOfArgs;
    
public:
    cache_t(const char *name, void *args[], int numberOfArgs);
    
    bucket *buckets() { return _buckets; };
    mask_t capacity() { return _capacity; }
    mask_t occupied() { return _occupied; }
    
    const char *name() { return _name; }
    
    bucket *bucketsWithCount(uint32_t *count)
    {
        *count = _occupied;
        return _buckets;
    }
    
    void initialize();
    void addCache(const void *target, const IMP imp);
    void expand();
    void reallocate(mask_t oldCapacity, mask_t newCapacity);
    static size_t bytesForCapacity(mask_t capacity);
};

struct ImpMap {
    CFMutableDictionaryRef dictRef;
public:
    ImpMap() {
        dictRef = CFDictionaryCreateMutable(kCFAllocatorDefault, 10, NULL, NULL);
    }
    
    void addCache(const char *key, cache_t *cache) {
        if (CFDictionaryGetValue(dictRef, key)) { return; }
//        NSLog(@"cache key: %s", key);
        CFDictionarySetValue(dictRef, key, cache);
    }
    
    bool cacheExist(const char *key) {
        if (CFDictionaryGetValue(dictRef, key)) return true;
        return false;
    }
    
    cache_t *cache(const char *key) {
        const void *value = CFDictionaryGetValue(dictRef, key);
        if (value == NULL) { return NULL; }
        return (cache_t *)value;
    }
};

cache_t *ant_cacheCreate(const char *name, void *args[], int numberOfArgs);

//static struct ImpMap map;
