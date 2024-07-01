-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_272 is
end project_tb_272;

architecture project_tb_arch_272 of project_tb_272 is
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

constant SCENARIO_LENGTH : integer := 541;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (1,0,190,0,0,0,19,0,0,0,92,0,197,0,178,0,190,0,194,0,113,0,187,0,0,0,142,0,111,0,0,0,136,0,0,0,133,0,108,0,1,0,222,0,0,0,180,0,173,0,59,0,179,0,136,0,53,0,163,0,55,0,229,0,0,0,5,0,101,0,48,0,0,0,181,0,37,0,161,0,0,0,51,0,235,0,1,0,0,0,0,0,195,0,241,0,149,0,26,0,0,0,7,0,148,0,163,0,129,0,125,0,31,0,0,0,26,0,15,0,0,0,55,0,247,0,210,0,124,0,0,0,29,0,0,0,42,0,219,0,0,0,168,0,210,0,231,0,0,0,111,0,196,0,214,0,253,0,224,0,27,0,0,0,241,0,142,0,59,0,0,0,122,0,59,0,29,0,26,0,202,0,250,0,45,0,160,0,28,0,76,0,100,0,244,0,187,0,167,0,154,0,224,0,0,0,0,0,152,0,158,0,54,0,214,0,158,0,0,0,225,0,246,0,241,0,4,0,244,0,0,0,0,0,200,0,235,0,153,0,117,0,159,0,50,0,183,0,0,0,0,0,125,0,0,0,214,0,208,0,216,0,157,0,179,0,212,0,127,0,63,0,174,0,202,0,0,0,61,0,246,0,97,0,160,0,45,0,91,0,0,0,0,0,124,0,161,0,138,0,0,0,0,0,221,0,0,0,47,0,129,0,230,0,147,0,0,0,222,0,217,0,160,0,157,0,146,0,172,0,11,0,145,0,0,0,172,0,193,0,164,0,182,0,216,0,21,0,65,0,61,0,16,0,47,0,115,0,29,0,58,0,0,0,63,0,182,0,14,0,162,0,0,0,171,0,158,0,91,0,3,0,135,0,13,0,0,0,0,0,13,0,204,0,0,0,0,0,102,0,86,0,115,0,128,0,76,0,59,0,78,0,200,0,42,0,0,0,190,0,90,0,51,0,130,0,225,0,0,0,224,0,7,0,5,0,110,0,213,0,232,0,130,0,218,0,172,0,86,0,91,0,150,0,39,0,96,0,14,0,0,0,194,0,22,0,0,0,212,0,63,0,110,0,37,0,0,0,0,0,255,0,0,0,0,0,37,0,162,0,72,0,65,0,136,0,98,0,0,0,111,0,68,0,0,0,208,0,8,0,81,0,221,0,106,0,244,0,211,0,93,0,99,0,0,0,157,0,38,0,8,0,0,0,214,0,38,0,73,0,0,0,175,0,125,0,99,0,55,0,181,0,225,0,160,0,0,0,130,0,17,0,0,0,68,0,0,0,193,0,0,0,167,0,19,0,154,0,204,0,235,0,0,0,236,0,191,0,0,0,234,0,0,0,66,0,216,0,0,0,0,0,111,0,0,0,199,0,0,0,8,0,174,0,59,0,0,0,57,0,176,0,18,0,99,0,212,0,0,0,0,0,225,0,69,0,179,0,0,0,161,0,186,0,193,0,0,0,230,0,0,0,0,0,120,0,105,0,24,0,168,0,63,0,0,0,1,0,150,0,91,0,188,0,109,0,0,0,0,0,0,0,161,0,81,0,118,0,0,0,81,0,200,0,0,0,201,0,245,0,15,0,0,0,87,0,185,0,25,0,175,0,0,0,119,0,254,0,235,0,17,0,233,0,254,0,230,0,149,0,243,0,27,0,0,0,0,0,2,0,247,0,243,0,145,0,103,0,182,0,33,0,0,0,0,0,227,0,41,0,0,0,0,0,107,0,204,0,139,0,2,0,130,0,61,0,36,0,235,0,217,0,29,0,163,0,0,0,158,0,147,0,151,0,179,0,0,0,92,0,254,0,91,0,43,0,59,0,0,0,135,0,110,0,162,0,0,0,191,0,85,0,0,0,48,0,0,0,134,0,251,0,82,0,0,0,88,0,121,0,241,0,148,0,82,0,0,0,222,0,0,0,234,0,33,0,43,0,200,0,145,0,39,0,3,0,110,0,0,0,0,0,83,0,108,0,44,0,250,0,173,0,115,0,60,0,178,0,195,0,0,0,79,0,196,0,43,0,0,0,73,0,0,0,18,0,138,0,0,0,143,0,0,0,78,0,0,0,0,0,191,0,204,0,193,0,0,0,157,0,125,0,25,0,217,0,32,0,172,0,240,0,130,0,132,0,54,0,45,0,108,0,0,0,0,0,68,0,97,0,39,0,98,0,213,0,40,0,223,0,100,0,0,0,75,0,0,0,225,0,0,0,166,0,145,0,95,0,84,0,0,0,0,0,99,0,0,0,194,0,0,0,216,0,0,0,57,0,150,0,107,0,152,0,18,0,0,0,142,0,108,0,0,0,79,0,0,0,116,0,135,0,185,0,0,0,89,0,222,0,118,0,0,0,0,0,40,0,223,0,0,0,218,0,190,0,249,0,248,0,197,0,213,0,32,0,0,0,4,0,239,0,0,0,201,0,213,0,70,0,249,0);
signal scenario_full  : scenario_type := (1,31,190,31,190,30,19,31,19,30,92,31,197,31,178,31,190,31,194,31,113,31,187,31,187,30,142,31,111,31,111,30,136,31,136,30,133,31,108,31,1,31,222,31,222,30,180,31,173,31,59,31,179,31,136,31,53,31,163,31,55,31,229,31,229,30,5,31,101,31,48,31,48,30,181,31,37,31,161,31,161,30,51,31,235,31,1,31,1,30,1,29,195,31,241,31,149,31,26,31,26,30,7,31,148,31,163,31,129,31,125,31,31,31,31,30,26,31,15,31,15,30,55,31,247,31,210,31,124,31,124,30,29,31,29,30,42,31,219,31,219,30,168,31,210,31,231,31,231,30,111,31,196,31,214,31,253,31,224,31,27,31,27,30,241,31,142,31,59,31,59,30,122,31,59,31,29,31,26,31,202,31,250,31,45,31,160,31,28,31,76,31,100,31,244,31,187,31,167,31,154,31,224,31,224,30,224,29,152,31,158,31,54,31,214,31,158,31,158,30,225,31,246,31,241,31,4,31,244,31,244,30,244,29,200,31,235,31,153,31,117,31,159,31,50,31,183,31,183,30,183,29,125,31,125,30,214,31,208,31,216,31,157,31,179,31,212,31,127,31,63,31,174,31,202,31,202,30,61,31,246,31,97,31,160,31,45,31,91,31,91,30,91,29,124,31,161,31,138,31,138,30,138,29,221,31,221,30,47,31,129,31,230,31,147,31,147,30,222,31,217,31,160,31,157,31,146,31,172,31,11,31,145,31,145,30,172,31,193,31,164,31,182,31,216,31,21,31,65,31,61,31,16,31,47,31,115,31,29,31,58,31,58,30,63,31,182,31,14,31,162,31,162,30,171,31,158,31,91,31,3,31,135,31,13,31,13,30,13,29,13,31,204,31,204,30,204,29,102,31,86,31,115,31,128,31,76,31,59,31,78,31,200,31,42,31,42,30,190,31,90,31,51,31,130,31,225,31,225,30,224,31,7,31,5,31,110,31,213,31,232,31,130,31,218,31,172,31,86,31,91,31,150,31,39,31,96,31,14,31,14,30,194,31,22,31,22,30,212,31,63,31,110,31,37,31,37,30,37,29,255,31,255,30,255,29,37,31,162,31,72,31,65,31,136,31,98,31,98,30,111,31,68,31,68,30,208,31,8,31,81,31,221,31,106,31,244,31,211,31,93,31,99,31,99,30,157,31,38,31,8,31,8,30,214,31,38,31,73,31,73,30,175,31,125,31,99,31,55,31,181,31,225,31,160,31,160,30,130,31,17,31,17,30,68,31,68,30,193,31,193,30,167,31,19,31,154,31,204,31,235,31,235,30,236,31,191,31,191,30,234,31,234,30,66,31,216,31,216,30,216,29,111,31,111,30,199,31,199,30,8,31,174,31,59,31,59,30,57,31,176,31,18,31,99,31,212,31,212,30,212,29,225,31,69,31,179,31,179,30,161,31,186,31,193,31,193,30,230,31,230,30,230,29,120,31,105,31,24,31,168,31,63,31,63,30,1,31,150,31,91,31,188,31,109,31,109,30,109,29,109,28,161,31,81,31,118,31,118,30,81,31,200,31,200,30,201,31,245,31,15,31,15,30,87,31,185,31,25,31,175,31,175,30,119,31,254,31,235,31,17,31,233,31,254,31,230,31,149,31,243,31,27,31,27,30,27,29,2,31,247,31,243,31,145,31,103,31,182,31,33,31,33,30,33,29,227,31,41,31,41,30,41,29,107,31,204,31,139,31,2,31,130,31,61,31,36,31,235,31,217,31,29,31,163,31,163,30,158,31,147,31,151,31,179,31,179,30,92,31,254,31,91,31,43,31,59,31,59,30,135,31,110,31,162,31,162,30,191,31,85,31,85,30,48,31,48,30,134,31,251,31,82,31,82,30,88,31,121,31,241,31,148,31,82,31,82,30,222,31,222,30,234,31,33,31,43,31,200,31,145,31,39,31,3,31,110,31,110,30,110,29,83,31,108,31,44,31,250,31,173,31,115,31,60,31,178,31,195,31,195,30,79,31,196,31,43,31,43,30,73,31,73,30,18,31,138,31,138,30,143,31,143,30,78,31,78,30,78,29,191,31,204,31,193,31,193,30,157,31,125,31,25,31,217,31,32,31,172,31,240,31,130,31,132,31,54,31,45,31,108,31,108,30,108,29,68,31,97,31,39,31,98,31,213,31,40,31,223,31,100,31,100,30,75,31,75,30,225,31,225,30,166,31,145,31,95,31,84,31,84,30,84,29,99,31,99,30,194,31,194,30,216,31,216,30,57,31,150,31,107,31,152,31,18,31,18,30,142,31,108,31,108,30,79,31,79,30,116,31,135,31,185,31,185,30,89,31,222,31,118,31,118,30,118,29,40,31,223,31,223,30,218,31,190,31,249,31,248,31,197,31,213,31,32,31,32,30,4,31,239,31,239,30,201,31,213,31,70,31,249,31);

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
