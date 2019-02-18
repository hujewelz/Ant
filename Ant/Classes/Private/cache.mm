//
//  cache.m
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

#import "cache.h"
#import <CoreFoundation/CoreFoundation.h>

#define INIT_CACHE_SIZE 10

bucket *allocateBuckets(mask_t capacity);

cache_t::cache_t(const char *name, void *args[], int numberOfArgs)
:_name(name), _args(args), _numOfArgs(numberOfArgs)
{
    initialize();
}

void cache_t::initialize()
{
    bzero(this, sizeof(*this));
    _buckets = NULL;
}

void cache_t::addCache(const void *target, IMP imp)
{
    // 拓容
    if (_occupied >= _capacity) {
        expand();
    }
    struct bucket_t *b = (struct bucket_t *)calloc(sizeof(bucket_t), 1);
    b->target = target;
    b->imp = imp;
    _buckets[_occupied++] = b;
}

void cache_t::expand() {
    mask_t oldCapacity = capacity();
    mask_t newCapacity = oldCapacity ? oldCapacity*2 : INIT_CACHE_SIZE;
    reallocate(oldCapacity, newCapacity);
}

void cache_t::reallocate(mask_t oldCapacity, mask_t newCapacity)
{
    bucket *oldBuckets = buckets();
    bucket *newBuckets = allocateBuckets(newCapacity);
    if (oldBuckets) {
        memcpy(newBuckets, oldBuckets, oldCapacity);
    }
    _buckets = newBuckets;
    _capacity = newCapacity;
}

cache_t *ant_cacheCreate(const char *name, void *args[], int numberOfArgs) {
    cache_t *cache = (cache_t *)malloc(sizeof(cache_t));
    cache->initialize();
    cache->_name = name;
    cache->_numOfArgs = numberOfArgs;
    cache->_args = args;
    return cache;
}

size_t cache_t::bytesForCapacity(mask_t capacity)
{
    return sizeof(bucket) * (capacity /*+ 1*/);
}

bucket *allocateBuckets(mask_t capacity)
{
    bucket *newBuckets = (bucket *)calloc(cache_t::bytesForCapacity(capacity), 1);
    return newBuckets;
}
