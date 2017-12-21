/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights
 * reserved.
 */
package cn.org.bjca.redis.gen.utils;

import freemarker.template.Configuration;
import freemarker.template.Template;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;

import static freemarker.template.Configuration.VERSION_2_3_19;

/**
 * FreeMarkers工具类
 * @author FeiYue
 * @version 1.0
 */
public class FreeMarkers {

    private static Configuration freeMarkerConfigurer;

    public static String renderString(String templateString, Map<String, ?> model) {
        try {
            StringWriter result = new StringWriter();
            Template t = new Template("name", new StringReader(templateString), freeMarkerConfigurer);
            t.process(model, result);
            return result.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String renderTemplate(Template template, Object model) {
        try {
            StringWriter result = new StringWriter();
            template.process(model, result);
            return result.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static Configuration buildConfiguration() throws IOException {
        Configuration cfg = new Configuration(VERSION_2_3_19);
        cfg.setClassLoaderForTemplateLoading(FreeMarkers.class.getClassLoader(),"");
        return cfg;
    }

    public void setFreeMarkerConfigurer(Configuration freeMarkerConfigurer) {
        FreeMarkers.freeMarkerConfigurer = freeMarkerConfigurer;
    }

    /**
     * args[0] 存储路径
     * args[1] IP
     * args[2] PORT
     * args[3] 节点数量
     *
     * */
    public static void main(String[] args) throws IOException {
        String savePath = "";
        if (!StringUtils.isEmpty(args[0])) {
            savePath = args[0];
        } else {
            System.out.println("路径空");
            System.exit(1994);
        }
        String ip = "";
        if (!StringUtils.isEmpty(args[1])) {
            ip = args[1];
        } else {
            System.out.println("ip空");
            System.exit(1994);
        }
        int port = 7000;
        if (!StringUtils.isEmpty(args[2])) {
            port = Integer.valueOf(args[2]);
        }
        freeMarkerConfigurer = buildConfiguration();
        Template tpl = freeMarkerConfigurer.getTemplate("redis-properties.ftl", "UTF-8");
        Map<String, String> model = new HashMap<String, String>();
        model.put("ip", ip);
        model.put("port", String.valueOf(port));
        String rendered = renderTemplate(tpl, model);
        FileUtils.writeStringToFile(new File(savePath + "/redis-" + port + ".conf"), rendered);
    }

}
