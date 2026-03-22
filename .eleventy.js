const fs = require("fs");
const path = require("path");
const pluginRss = require("@11ty/eleventy-plugin-rss");

module.exports = function (eleventyConfig) {
  function getSourceAssetPath(assetUrl) {
    if (typeof assetUrl !== "string" || !assetUrl.startsWith("/")) {
      return null;
    }

    return path.join(process.cwd(), "src", ...assetUrl.slice(1).split("/"));
  }

  eleventyConfig.addPlugin(pluginRss);
  eleventyConfig.addFilter("date", (dateVal, format) => {
    const d = new Date(dateVal);
    if (format === "%B %d, %Y") {
      return d.toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" });
    }
    if (format === "MMMM dd, yyyy") {
      return d.toLocaleDateString("en-GB", { year: "numeric", month: "long", day: "2-digit" });
    }
    if (format === "%Y-%m-%d") {
      return d.toISOString().slice(0, 10);
    }
    return d.toLocaleDateString("en-GB");
  });

  eleventyConfig.addPassthroughCopy("src/css");
  eleventyConfig.addPassthroughCopy("src/favicon.svg");
  eleventyConfig.addPassthroughCopy("src/images");
  eleventyConfig.addPassthroughCopy({ "src/posts/*.md": "downloads" });
  eleventyConfig.addPassthroughCopy("src/downloads");

  eleventyConfig.addShortcode("downloadLink", function(filename, label) {
    return `<a href="/downloads/${filename}" download class="download-link">${label}</a>`;
  });

  eleventyConfig.addFilter("relatedPosts", function(allPosts, currentTags, currentUrl) {
    if (!currentTags || !allPosts) return [];
    return allPosts
      .filter(post =>
        post.url !== currentUrl &&
        post.data.tags &&
        post.data.tags.some(tag => currentTags.includes(tag))
      )
      .slice(0, 3);
  });

  eleventyConfig.addFilter("readingTime", function (content) {
    const words = content.split(/\s+/).length;
    return Math.ceil(words / 200) + " min read";
  });

  eleventyConfig.addFilter("assetExists", function (assetUrl) {
    const assetPath = getSourceAssetPath(assetUrl);
    return assetPath ? fs.existsSync(assetPath) : false;
  });

  eleventyConfig.addFilter("existingAssets", function (assetUrls) {
    if (!Array.isArray(assetUrls)) return [];
    return assetUrls.filter(assetUrl => {
      const assetPath = getSourceAssetPath(assetUrl);
      return assetPath ? fs.existsSync(assetPath) : false;
    });
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
