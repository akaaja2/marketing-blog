module.exports = function (eleventyConfig) {
  eleventyConfig.addFilter("date", (dateVal, format) => {
    const d = new Date(dateVal);
    if (format === "MMMM dd, yyyy") {
      return d.toLocaleDateString("en-GB", { year: "numeric", month: "long", day: "2-digit" });
    }
    return d.toLocaleDateString("en-GB");
  });

  eleventyConfig.addPassthroughCopy("src/css");

  eleventyConfig.addFilter("readingTime", function (content) {
    const words = content.split(/\s+/).length;
    return Math.ceil(words / 200) + " min read";
  });

  eleventyConfig.addCollection("tagList", function (collectionApi) {
    const tagSet = new Set();
    collectionApi.getAll().forEach(item => {
      (item.data.tags || []).forEach(tag => {
        if (tag !== "post") tagSet.add(tag);
      });
    });
    return [...tagSet];
  });

  return {
    dir: {
      input: "src",
      output: "_site",
      includes: "_includes",
    },
  };
};
