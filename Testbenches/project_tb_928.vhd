-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 282;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (108,0,252,0,153,0,238,0,13,0,77,0,28,0,0,0,135,0,106,0,71,0,184,0,205,0,182,0,0,0,0,0,0,0,6,0,46,0,15,0,0,0,241,0,136,0,0,0,8,0,179,0,81,0,140,0,0,0,98,0,146,0,227,0,0,0,199,0,7,0,0,0,97,0,21,0,101,0,54,0,0,0,16,0,54,0,13,0,175,0,0,0,68,0,131,0,0,0,1,0,77,0,28,0,7,0,222,0,70,0,44,0,1,0,80,0,1,0,0,0,46,0,206,0,64,0,114,0,0,0,27,0,26,0,0,0,230,0,210,0,136,0,61,0,68,0,72,0,0,0,0,0,0,0,0,0,0,0,232,0,122,0,137,0,183,0,0,0,135,0,249,0,246,0,157,0,4,0,188,0,77,0,112,0,0,0,0,0,1,0,188,0,48,0,224,0,0,0,113,0,114,0,0,0,89,0,250,0,189,0,39,0,149,0,225,0,56,0,152,0,54,0,131,0,67,0,0,0,178,0,42,0,244,0,243,0,170,0,125,0,78,0,175,0,148,0,136,0,24,0,115,0,34,0,0,0,0,0,201,0,176,0,197,0,182,0,206,0,159,0,0,0,218,0,0,0,11,0,190,0,22,0,47,0,218,0,72,0,21,0,54,0,0,0,0,0,0,0,26,0,13,0,150,0,131,0,177,0,184,0,0,0,93,0,244,0,182,0,0,0,59,0,1,0,0,0,0,0,184,0,0,0,92,0,17,0,185,0,196,0,57,0,74,0,210,0,62,0,0,0,255,0,145,0,226,0,93,0,0,0,24,0,15,0,0,0,254,0,0,0,119,0,108,0,106,0,217,0,7,0,57,0,164,0,38,0,68,0,220,0,238,0,172,0,195,0,167,0,118,0,231,0,206,0,139,0,243,0,183,0,67,0,167,0,225,0,131,0,0,0,178,0,115,0,237,0,55,0,113,0,135,0,231,0,35,0,94,0,101,0,0,0,197,0,177,0,235,0,13,0,72,0,84,0,40,0,156,0,36,0,32,0,90,0,205,0,25,0,212,0,224,0,12,0,24,0,189,0,141,0,212,0,135,0,101,0,132,0,193,0,68,0,0,0,199,0,18,0,95,0,25,0,225,0,73,0,186,0,120,0,89,0,229,0,0,0,11,0,255,0,128,0,159,0,0,0,182,0,0,0,0,0,1,0,93,0,163,0,139,0,238,0,136,0,169,0,36,0,179,0,0,0,98,0,95,0,175,0,230,0,43,0,219,0);
signal scenario_full  : scenario_type := (108,31,252,31,153,31,238,31,13,31,77,31,28,31,28,30,135,31,106,31,71,31,184,31,205,31,182,31,182,30,182,29,182,28,6,31,46,31,15,31,15,30,241,31,136,31,136,30,8,31,179,31,81,31,140,31,140,30,98,31,146,31,227,31,227,30,199,31,7,31,7,30,97,31,21,31,101,31,54,31,54,30,16,31,54,31,13,31,175,31,175,30,68,31,131,31,131,30,1,31,77,31,28,31,7,31,222,31,70,31,44,31,1,31,80,31,1,31,1,30,46,31,206,31,64,31,114,31,114,30,27,31,26,31,26,30,230,31,210,31,136,31,61,31,68,31,72,31,72,30,72,29,72,28,72,27,72,26,232,31,122,31,137,31,183,31,183,30,135,31,249,31,246,31,157,31,4,31,188,31,77,31,112,31,112,30,112,29,1,31,188,31,48,31,224,31,224,30,113,31,114,31,114,30,89,31,250,31,189,31,39,31,149,31,225,31,56,31,152,31,54,31,131,31,67,31,67,30,178,31,42,31,244,31,243,31,170,31,125,31,78,31,175,31,148,31,136,31,24,31,115,31,34,31,34,30,34,29,201,31,176,31,197,31,182,31,206,31,159,31,159,30,218,31,218,30,11,31,190,31,22,31,47,31,218,31,72,31,21,31,54,31,54,30,54,29,54,28,26,31,13,31,150,31,131,31,177,31,184,31,184,30,93,31,244,31,182,31,182,30,59,31,1,31,1,30,1,29,184,31,184,30,92,31,17,31,185,31,196,31,57,31,74,31,210,31,62,31,62,30,255,31,145,31,226,31,93,31,93,30,24,31,15,31,15,30,254,31,254,30,119,31,108,31,106,31,217,31,7,31,57,31,164,31,38,31,68,31,220,31,238,31,172,31,195,31,167,31,118,31,231,31,206,31,139,31,243,31,183,31,67,31,167,31,225,31,131,31,131,30,178,31,115,31,237,31,55,31,113,31,135,31,231,31,35,31,94,31,101,31,101,30,197,31,177,31,235,31,13,31,72,31,84,31,40,31,156,31,36,31,32,31,90,31,205,31,25,31,212,31,224,31,12,31,24,31,189,31,141,31,212,31,135,31,101,31,132,31,193,31,68,31,68,30,199,31,18,31,95,31,25,31,225,31,73,31,186,31,120,31,89,31,229,31,229,30,11,31,255,31,128,31,159,31,159,30,182,31,182,30,182,29,1,31,93,31,163,31,139,31,238,31,136,31,169,31,36,31,179,31,179,30,98,31,95,31,175,31,230,31,43,31,219,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
