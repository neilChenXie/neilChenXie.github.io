module Jekyll
  class TagPageGenerator < Generator
    safe true

    def generate(site)
      # 如果禁用了标签生成，则退出
      if site.config['skip_tag_generation']
        Jekyll.logger.info "Tag Generator:", "Tag generation is disabled"
        return
      end

      begin
        tags = site.posts.docs.flat_map { |post| post.data['tags'] || [] }.uniq.compact
        
        if tags.empty?
          Jekyll.logger.info "Tag Generator:", "No tags found in posts"
          return
        end

        Jekyll.logger.info "Tag Generator:", "Found #{tags.length} unique tags"
        
        tags.each do |tag|
          generate_tag_page(site, tag)
        end
      rescue => e
        Jekyll.logger.error "Tag Generator Error:", e.message
        Jekyll.logger.error "Tag Generator Error:", e.backtrace.join("\n")
      end
    end

    private

    def generate_tag_page(site, tag)
      tag_dir = File.join(site.source, '_tags_page')
      tag_file = File.join(tag_dir, "#{tag}.md")

      begin
        # 如果文件不存在，则创建它
        unless File.exist?(tag_file)
          FileUtils.mkdir_p(tag_dir) unless File.exist?(tag_dir)
          
          content = "---\nlayout: page_tag\ntitle: #{tag}\n---\n"
          File.write(tag_file, content)
          
          Jekyll.logger.info "Tag Generator:", "Generated tag page for '#{tag}'"
        end
      rescue => e
        Jekyll.logger.error "Tag Generator Error:", "Failed to generate tag '#{tag}': #{e.message}"
      end
    end
  end
end
