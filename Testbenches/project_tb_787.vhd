-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_787 is
end project_tb_787;

architecture project_tb_arch_787 of project_tb_787 is
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

constant SCENARIO_LENGTH : integer := 359;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,141,0,0,0,76,0,209,0,153,0,130,0,88,0,172,0,174,0,38,0,59,0,101,0,115,0,155,0,186,0,1,0,0,0,222,0,137,0,233,0,92,0,51,0,0,0,0,0,111,0,8,0,222,0,153,0,89,0,40,0,2,0,99,0,174,0,0,0,135,0,153,0,0,0,109,0,113,0,224,0,109,0,245,0,100,0,38,0,42,0,90,0,0,0,168,0,246,0,0,0,86,0,98,0,47,0,81,0,3,0,241,0,195,0,0,0,200,0,178,0,0,0,145,0,22,0,16,0,123,0,203,0,245,0,0,0,207,0,105,0,85,0,24,0,77,0,0,0,0,0,117,0,31,0,0,0,0,0,226,0,105,0,171,0,166,0,25,0,146,0,0,0,146,0,99,0,0,0,90,0,44,0,10,0,250,0,0,0,166,0,8,0,30,0,0,0,0,0,0,0,17,0,49,0,125,0,85,0,1,0,0,0,0,0,159,0,0,0,24,0,0,0,151,0,4,0,21,0,27,0,190,0,54,0,199,0,0,0,169,0,46,0,0,0,147,0,63,0,211,0,0,0,0,0,191,0,243,0,196,0,36,0,118,0,0,0,0,0,143,0,252,0,54,0,104,0,0,0,104,0,159,0,0,0,49,0,30,0,226,0,180,0,165,0,185,0,172,0,0,0,0,0,0,0,0,0,217,0,0,0,131,0,132,0,73,0,223,0,173,0,83,0,181,0,0,0,136,0,55,0,31,0,0,0,216,0,203,0,241,0,138,0,0,0,103,0,136,0,238,0,125,0,39,0,107,0,0,0,247,0,201,0,0,0,78,0,95,0,4,0,63,0,191,0,146,0,111,0,135,0,113,0,0,0,13,0,202,0,138,0,176,0,46,0,120,0,60,0,0,0,142,0,98,0,66,0,0,0,156,0,85,0,0,0,53,0,17,0,0,0,110,0,156,0,146,0,85,0,162,0,93,0,125,0,119,0,171,0,132,0,253,0,0,0,189,0,0,0,19,0,99,0,147,0,196,0,132,0,166,0,91,0,204,0,0,0,175,0,70,0,189,0,23,0,185,0,129,0,27,0,85,0,1,0,2,0,138,0,0,0,0,0,188,0,42,0,120,0,162,0,41,0,169,0,182,0,11,0,13,0,224,0,31,0,0,0,176,0,135,0,108,0,193,0,7,0,149,0,108,0,6,0,10,0,202,0,11,0,0,0,0,0,53,0,0,0,20,0,67,0,147,0,148,0,33,0,81,0,74,0,158,0,229,0,216,0,39,0,33,0,60,0,0,0,0,0,109,0,0,0,0,0,0,0,34,0,122,0,234,0,180,0,111,0,17,0,71,0,237,0,116,0,247,0,0,0,131,0,47,0,0,0,80,0,214,0,217,0,0,0,174,0,159,0,55,0,127,0,151,0,0,0,205,0,148,0,0,0,0,0,172,0,35,0,0,0,182,0,235,0,106,0,203,0,90,0,158,0,70,0,119,0,244,0,173,0,172,0,0,0,227,0,0,0,141,0,138,0,0,0,0,0,0,0,93,0,146,0,216,0,143,0,211,0,174,0,19,0,0,0,219,0,123,0,131,0,180,0,3,0,0,0,75,0,193,0);
signal scenario_full  : scenario_type := (0,0,141,31,141,30,76,31,209,31,153,31,130,31,88,31,172,31,174,31,38,31,59,31,101,31,115,31,155,31,186,31,1,31,1,30,222,31,137,31,233,31,92,31,51,31,51,30,51,29,111,31,8,31,222,31,153,31,89,31,40,31,2,31,99,31,174,31,174,30,135,31,153,31,153,30,109,31,113,31,224,31,109,31,245,31,100,31,38,31,42,31,90,31,90,30,168,31,246,31,246,30,86,31,98,31,47,31,81,31,3,31,241,31,195,31,195,30,200,31,178,31,178,30,145,31,22,31,16,31,123,31,203,31,245,31,245,30,207,31,105,31,85,31,24,31,77,31,77,30,77,29,117,31,31,31,31,30,31,29,226,31,105,31,171,31,166,31,25,31,146,31,146,30,146,31,99,31,99,30,90,31,44,31,10,31,250,31,250,30,166,31,8,31,30,31,30,30,30,29,30,28,17,31,49,31,125,31,85,31,1,31,1,30,1,29,159,31,159,30,24,31,24,30,151,31,4,31,21,31,27,31,190,31,54,31,199,31,199,30,169,31,46,31,46,30,147,31,63,31,211,31,211,30,211,29,191,31,243,31,196,31,36,31,118,31,118,30,118,29,143,31,252,31,54,31,104,31,104,30,104,31,159,31,159,30,49,31,30,31,226,31,180,31,165,31,185,31,172,31,172,30,172,29,172,28,172,27,217,31,217,30,131,31,132,31,73,31,223,31,173,31,83,31,181,31,181,30,136,31,55,31,31,31,31,30,216,31,203,31,241,31,138,31,138,30,103,31,136,31,238,31,125,31,39,31,107,31,107,30,247,31,201,31,201,30,78,31,95,31,4,31,63,31,191,31,146,31,111,31,135,31,113,31,113,30,13,31,202,31,138,31,176,31,46,31,120,31,60,31,60,30,142,31,98,31,66,31,66,30,156,31,85,31,85,30,53,31,17,31,17,30,110,31,156,31,146,31,85,31,162,31,93,31,125,31,119,31,171,31,132,31,253,31,253,30,189,31,189,30,19,31,99,31,147,31,196,31,132,31,166,31,91,31,204,31,204,30,175,31,70,31,189,31,23,31,185,31,129,31,27,31,85,31,1,31,2,31,138,31,138,30,138,29,188,31,42,31,120,31,162,31,41,31,169,31,182,31,11,31,13,31,224,31,31,31,31,30,176,31,135,31,108,31,193,31,7,31,149,31,108,31,6,31,10,31,202,31,11,31,11,30,11,29,53,31,53,30,20,31,67,31,147,31,148,31,33,31,81,31,74,31,158,31,229,31,216,31,39,31,33,31,60,31,60,30,60,29,109,31,109,30,109,29,109,28,34,31,122,31,234,31,180,31,111,31,17,31,71,31,237,31,116,31,247,31,247,30,131,31,47,31,47,30,80,31,214,31,217,31,217,30,174,31,159,31,55,31,127,31,151,31,151,30,205,31,148,31,148,30,148,29,172,31,35,31,35,30,182,31,235,31,106,31,203,31,90,31,158,31,70,31,119,31,244,31,173,31,172,31,172,30,227,31,227,30,141,31,138,31,138,30,138,29,138,28,93,31,146,31,216,31,143,31,211,31,174,31,19,31,19,30,219,31,123,31,131,31,180,31,3,31,3,30,75,31,193,31);

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
