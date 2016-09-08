package ${packageName}.config.database;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.jooq.DSLContext;
import org.jooq.SQLDialect;
import org.jooq.impl.DSL;
import org.jooq.impl.DefaultConfiguration;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import javax.annotation.Generated;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.JdbcTemplate;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.SQLException;

/**
* This is generated by Sloth.
*/
@Generated(
    value = {
    "http://www.xxxxx.org",
    "Sloth version:1.0"
    },
    comments = "This class is generated by Sloth"
)
@Configuration
@MapperScan("${packageName}.mapper")
public class DB {

    private final Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private DBConfig dbConfig;


    @Bean(destroyMethod = "close")
    @Primary
    public DataSource dataSource(){
        HikariConfig hiConfig = new HikariConfig();
        String url = "jdbc:mysql://" + dbConfig.getDBHost() + ":" + dbConfig.getDBPort() + "/" + dbConfig.getDBName()+"?useUnicode=true&cautoReconnect=true&characterEncoding=utf8";
        hiConfig.setDriverClassName("com.mysql.jdbc.Driver");
        hiConfig.setAutoCommit(false);
        hiConfig.setJdbcUrl(url);
        hiConfig.setUsername(dbConfig.getDBUser());
        hiConfig.setPassword(dbConfig.getDBPassword());
        DataSource dataSource = new HikariDataSource(hiConfig);
        log.info(">>>>dataSource init success:" + dataSource + "[jdbc:mysql://" + dbConfig.getDBHost() + ":" + dbConfig.getDBPort() + "/" + dbConfig.getDBName()+"]");
        return dataSource;
    }


    @Bean(name = "jdbcTemplate")
    @Primary
    JdbcTemplate jdbcTemplate(){
        return new JdbcTemplate(dataSource());
    }

    @Bean
    public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
        log.info(">>>>sqlSessionFactory init, dataSource:" + dataSource);
        final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);
        sessionFactory.setTypeAliasesPackage("${packageName}.model");
        return sessionFactory.getObject();
    }

    @Bean(name = "dSLContext")
    DSLContext getDSLContext(){
        org.jooq.Configuration defaultConfiguration = null;
        try {
            defaultConfiguration = new DefaultConfiguration().set(dataSource().getConnection()).set(SQLDialect.MYSQL);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return DSL.using(defaultConfiguration);
    }


}