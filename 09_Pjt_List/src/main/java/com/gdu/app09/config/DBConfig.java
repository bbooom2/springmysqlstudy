package com.gdu.app09.config;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
// application.properties 파일의 속성을 읽어오자
import org.springframework.core.env.Environment;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.TransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

@MapperScan(basePackages = {"com.gdu.app09.mapper"})  // @Mapper가 존재하는 패키지를 작성한다. 
@PropertySource(value={"classpath:application.properties"}) //리소스 바로 아래에 넣었기 때문에 저렇게만 적어주면 됨. 폴더 안에 넣었었다면 a/application.properties 이런식으로 기재하면 됨 리소스 폴더 안에만 모든 게 들어있으면 오케이. 프로퍼티를 불러오는 프로퍼티 소스는 스프링이 Bean을 자동으로만들어준다.  
@EnableTransactionManagement //트랜젝션처리를 하겠다 - 230425기준 셀렉트만 할거라 트랜젝션 필요 없긴 하지만 그냥 넣어놨음.
@Configuration
public class DBConfig {
	
	
	@Autowired
	private Environment env;
	
	
	// DB 접속에 관련된 Bean들 
	// HikariConfig Bean (application.properties 내용 옮기는 것. 프로퍼티 분리했던 이유는 gitignore에 application.properties를 처리해서 깃에는 안 올라가게 처리하기 위함) 
	@Bean
	public HikariConfig hikariConfig() { // 이걸 두번째 bean이 가져다 씀 
		HikariConfig hikariConfig = new HikariConfig();
		hikariConfig.setDriverClassName(env.getProperty("spring.datasource.hikari.driver-class-name")); // oracle.jdcb.OracleDriver가 들어감 
		hikariConfig.setJdbcUrl(env.getProperty("spring.datasource.hikari.jdbc-url")); // jdbc:oracle:thin:@localhost:1521:xe가 들어감 
		hikariConfig.setUsername(env.getProperty("spring.datasource.hikari.username")); // 유저네임이 들어감 
		hikariConfig.setPassword(env.getProperty("spring.datasource.hikari.password")); // 패스워드가 들어감 
		return hikariConfig;
	}
	
	
	// DriverManagerDataSource = > 히카리 그걸로 바꿔줄거임  
	// HikariDataSource Bean 필요 그 전에 HikariConfig Bean 필요 
	// HikariDataSource Bean
	@Bean(destroyMethod="close") // 홈페이지에 안내되어있는 내용 
	public HikariDataSource hikariDataSource() {  // 세번째 Bean이 가져다 씀 
		return new HikariDataSource( hikariConfig());  //히카리 컨피그를 요구하는 걸 적을 것 
	}
	
	// SqlSessionFactory Bean
	@Bean
	public SqlSessionFactory sqlSessionFactory() throws Exception { // 트라이 캐치필요한데 귀찮으니까 throws 사용하겠음 // 네번째 빈이 가져다 씀 
		SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
		bean.setDataSource(hikariDataSource()); // 위에 있는 데이타 소스 
		bean.setConfigLocation(new PathMatchingResourcePatternResolver().getResource(env.getProperty("mybatis.config-location")));
		bean.setMapperLocations(new PathMatchingResourcePatternResolver().getResources(env.getProperty("mybatis.mapper-locations")));
		return bean.getObject();
	}
	
	
	// SqlSessionTemplate Bean (기존의 SqlSession)  
	// 결론적으로 이걸 만들기 위해서. 최종적으로 방식이 달라졌지만 sql탬플릿을 만들기 위해 지금껏 달린 것. 
	@Bean
	public SqlSessionTemplate sqlSessionTemplate() throws Exception { // 위에 throws 해줬으니까. 근데 이것도 트라이 캐치 필요 
	return new SqlSessionTemplate(sqlSessionFactory()); // 공장에서 뽑아낸 것
	}
	
	// TransactionManager Bean 
	// HikariDataSource Bean이게 있어서 만들수 있음 
	// 이거하려면 transactionManager 허용 필요해서 애너테이션 해놨음.
	@Bean
	public TransactionManager transactionManager() { 
		return new DataSourceTransactionManager(hikariDataSource()); // 히카리빈에 있는 데이타소스
	}
}	
