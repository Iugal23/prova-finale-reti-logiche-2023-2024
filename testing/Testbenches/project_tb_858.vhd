-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_858 is
end project_tb_858;

architecture project_tb_arch_858 of project_tb_858 is
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

constant SCENARIO_LENGTH : integer := 410;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (199,0,0,0,145,0,99,0,122,0,114,0,197,0,166,0,94,0,0,0,83,0,51,0,0,0,40,0,253,0,183,0,166,0,227,0,92,0,154,0,161,0,209,0,0,0,54,0,0,0,0,0,65,0,122,0,213,0,104,0,0,0,100,0,202,0,163,0,29,0,149,0,142,0,60,0,0,0,0,0,74,0,29,0,21,0,83,0,155,0,150,0,87,0,196,0,0,0,66,0,205,0,141,0,86,0,170,0,84,0,37,0,25,0,212,0,10,0,198,0,231,0,0,0,0,0,61,0,156,0,167,0,155,0,137,0,98,0,113,0,3,0,153,0,0,0,174,0,0,0,132,0,0,0,60,0,97,0,0,0,20,0,200,0,117,0,102,0,3,0,132,0,194,0,167,0,0,0,140,0,119,0,120,0,61,0,202,0,233,0,190,0,138,0,0,0,197,0,23,0,117,0,11,0,85,0,36,0,39,0,0,0,228,0,17,0,217,0,134,0,43,0,83,0,198,0,44,0,0,0,0,0,125,0,55,0,161,0,107,0,213,0,237,0,0,0,202,0,241,0,0,0,45,0,170,0,248,0,200,0,44,0,222,0,74,0,202,0,143,0,95,0,253,0,5,0,223,0,162,0,27,0,106,0,16,0,188,0,245,0,31,0,26,0,200,0,90,0,94,0,135,0,0,0,72,0,132,0,134,0,169,0,166,0,149,0,27,0,221,0,192,0,4,0,38,0,233,0,51,0,167,0,29,0,162,0,142,0,167,0,43,0,210,0,246,0,168,0,104,0,18,0,10,0,26,0,77,0,14,0,157,0,56,0,0,0,123,0,91,0,209,0,212,0,55,0,130,0,0,0,136,0,164,0,0,0,117,0,119,0,73,0,42,0,137,0,180,0,0,0,104,0,80,0,31,0,67,0,59,0,0,0,65,0,207,0,98,0,202,0,196,0,0,0,158,0,215,0,0,0,151,0,39,0,3,0,0,0,0,0,180,0,0,0,21,0,0,0,223,0,199,0,111,0,189,0,0,0,0,0,166,0,29,0,0,0,62,0,125,0,0,0,205,0,184,0,0,0,244,0,84,0,6,0,121,0,184,0,92,0,191,0,107,0,118,0,71,0,209,0,2,0,131,0,216,0,233,0,193,0,39,0,0,0,248,0,0,0,180,0,0,0,167,0,62,0,209,0,83,0,0,0,215,0,196,0,49,0,188,0,58,0,139,0,169,0,0,0,177,0,254,0,0,0,198,0,48,0,0,0,2,0,185,0,127,0,35,0,105,0,59,0,0,0,49,0,154,0,6,0,187,0,44,0,101,0,108,0,0,0,150,0,23,0,19,0,0,0,0,0,172,0,0,0,0,0,33,0,0,0,189,0,0,0,243,0,237,0,224,0,176,0,114,0,219,0,1,0,0,0,31,0,222,0,0,0,132,0,29,0,103,0,114,0,10,0,74,0,102,0,0,0,39,0,123,0,0,0,0,0,89,0,0,0,0,0,177,0,228,0,0,0,0,0,239,0,0,0,164,0,102,0,0,0,178,0,0,0,227,0,123,0,223,0,23,0,234,0,53,0,0,0,184,0,246,0,181,0,8,0,195,0,0,0,217,0,196,0,0,0,137,0,0,0,139,0,0,0,128,0,174,0,0,0,180,0,223,0,126,0,38,0,60,0,70,0,0,0,126,0,0,0,0,0,230,0,12,0,111,0,161,0,0,0,198,0,230,0,50,0,0,0,217,0,139,0,0,0,55,0,217,0,159,0,115,0,138,0,172,0,3,0,0,0,91,0,146,0,91,0,217,0,158,0,151,0,243,0,214,0,234,0,169,0,167,0,0,0,41,0);
signal scenario_full  : scenario_type := (199,31,199,30,145,31,99,31,122,31,114,31,197,31,166,31,94,31,94,30,83,31,51,31,51,30,40,31,253,31,183,31,166,31,227,31,92,31,154,31,161,31,209,31,209,30,54,31,54,30,54,29,65,31,122,31,213,31,104,31,104,30,100,31,202,31,163,31,29,31,149,31,142,31,60,31,60,30,60,29,74,31,29,31,21,31,83,31,155,31,150,31,87,31,196,31,196,30,66,31,205,31,141,31,86,31,170,31,84,31,37,31,25,31,212,31,10,31,198,31,231,31,231,30,231,29,61,31,156,31,167,31,155,31,137,31,98,31,113,31,3,31,153,31,153,30,174,31,174,30,132,31,132,30,60,31,97,31,97,30,20,31,200,31,117,31,102,31,3,31,132,31,194,31,167,31,167,30,140,31,119,31,120,31,61,31,202,31,233,31,190,31,138,31,138,30,197,31,23,31,117,31,11,31,85,31,36,31,39,31,39,30,228,31,17,31,217,31,134,31,43,31,83,31,198,31,44,31,44,30,44,29,125,31,55,31,161,31,107,31,213,31,237,31,237,30,202,31,241,31,241,30,45,31,170,31,248,31,200,31,44,31,222,31,74,31,202,31,143,31,95,31,253,31,5,31,223,31,162,31,27,31,106,31,16,31,188,31,245,31,31,31,26,31,200,31,90,31,94,31,135,31,135,30,72,31,132,31,134,31,169,31,166,31,149,31,27,31,221,31,192,31,4,31,38,31,233,31,51,31,167,31,29,31,162,31,142,31,167,31,43,31,210,31,246,31,168,31,104,31,18,31,10,31,26,31,77,31,14,31,157,31,56,31,56,30,123,31,91,31,209,31,212,31,55,31,130,31,130,30,136,31,164,31,164,30,117,31,119,31,73,31,42,31,137,31,180,31,180,30,104,31,80,31,31,31,67,31,59,31,59,30,65,31,207,31,98,31,202,31,196,31,196,30,158,31,215,31,215,30,151,31,39,31,3,31,3,30,3,29,180,31,180,30,21,31,21,30,223,31,199,31,111,31,189,31,189,30,189,29,166,31,29,31,29,30,62,31,125,31,125,30,205,31,184,31,184,30,244,31,84,31,6,31,121,31,184,31,92,31,191,31,107,31,118,31,71,31,209,31,2,31,131,31,216,31,233,31,193,31,39,31,39,30,248,31,248,30,180,31,180,30,167,31,62,31,209,31,83,31,83,30,215,31,196,31,49,31,188,31,58,31,139,31,169,31,169,30,177,31,254,31,254,30,198,31,48,31,48,30,2,31,185,31,127,31,35,31,105,31,59,31,59,30,49,31,154,31,6,31,187,31,44,31,101,31,108,31,108,30,150,31,23,31,19,31,19,30,19,29,172,31,172,30,172,29,33,31,33,30,189,31,189,30,243,31,237,31,224,31,176,31,114,31,219,31,1,31,1,30,31,31,222,31,222,30,132,31,29,31,103,31,114,31,10,31,74,31,102,31,102,30,39,31,123,31,123,30,123,29,89,31,89,30,89,29,177,31,228,31,228,30,228,29,239,31,239,30,164,31,102,31,102,30,178,31,178,30,227,31,123,31,223,31,23,31,234,31,53,31,53,30,184,31,246,31,181,31,8,31,195,31,195,30,217,31,196,31,196,30,137,31,137,30,139,31,139,30,128,31,174,31,174,30,180,31,223,31,126,31,38,31,60,31,70,31,70,30,126,31,126,30,126,29,230,31,12,31,111,31,161,31,161,30,198,31,230,31,50,31,50,30,217,31,139,31,139,30,55,31,217,31,159,31,115,31,138,31,172,31,3,31,3,30,91,31,146,31,91,31,217,31,158,31,151,31,243,31,214,31,234,31,169,31,167,31,167,30,41,31);

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
