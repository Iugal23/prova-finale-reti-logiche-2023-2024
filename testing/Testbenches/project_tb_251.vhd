-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_251 is
end project_tb_251;

architecture project_tb_arch_251 of project_tb_251 is
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

constant SCENARIO_LENGTH : integer := 517;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (110,0,0,0,40,0,73,0,135,0,0,0,121,0,77,0,208,0,201,0,98,0,113,0,31,0,0,0,240,0,156,0,15,0,190,0,0,0,60,0,223,0,86,0,0,0,39,0,0,0,0,0,103,0,0,0,62,0,31,0,143,0,0,0,0,0,66,0,29,0,246,0,102,0,212,0,108,0,0,0,93,0,83,0,208,0,206,0,0,0,162,0,90,0,84,0,211,0,142,0,72,0,149,0,177,0,59,0,63,0,168,0,0,0,0,0,89,0,86,0,0,0,0,0,49,0,21,0,85,0,237,0,56,0,0,0,186,0,244,0,240,0,84,0,107,0,142,0,0,0,0,0,53,0,229,0,0,0,155,0,242,0,88,0,123,0,69,0,158,0,60,0,200,0,170,0,63,0,239,0,110,0,214,0,206,0,76,0,115,0,44,0,241,0,0,0,73,0,138,0,29,0,93,0,0,0,0,0,79,0,193,0,25,0,84,0,18,0,40,0,103,0,87,0,217,0,161,0,131,0,59,0,0,0,73,0,2,0,0,0,71,0,146,0,243,0,229,0,158,0,0,0,221,0,204,0,20,0,0,0,40,0,89,0,0,0,140,0,165,0,35,0,14,0,130,0,68,0,214,0,0,0,0,0,82,0,37,0,19,0,233,0,254,0,164,0,55,0,38,0,0,0,0,0,34,0,0,0,109,0,109,0,0,0,0,0,21,0,212,0,143,0,0,0,165,0,116,0,196,0,0,0,66,0,0,0,13,0,173,0,27,0,0,0,142,0,136,0,252,0,67,0,0,0,242,0,227,0,232,0,216,0,206,0,79,0,71,0,0,0,79,0,0,0,100,0,50,0,202,0,211,0,20,0,51,0,109,0,230,0,239,0,113,0,190,0,0,0,0,0,227,0,249,0,179,0,217,0,28,0,224,0,186,0,107,0,181,0,39,0,93,0,0,0,198,0,93,0,73,0,0,0,254,0,139,0,4,0,0,0,136,0,125,0,216,0,251,0,34,0,0,0,129,0,1,0,127,0,169,0,0,0,211,0,0,0,125,0,2,0,196,0,14,0,214,0,126,0,70,0,43,0,132,0,249,0,127,0,246,0,82,0,154,0,0,0,5,0,231,0,74,0,72,0,94,0,0,0,5,0,204,0,186,0,213,0,0,0,70,0,239,0,226,0,212,0,29,0,187,0,20,0,0,0,160,0,160,0,64,0,139,0,235,0,10,0,0,0,62,0,0,0,0,0,0,0,34,0,140,0,24,0,33,0,192,0,11,0,171,0,203,0,0,0,67,0,150,0,222,0,14,0,183,0,144,0,107,0,0,0,65,0,54,0,100,0,52,0,130,0,139,0,0,0,0,0,124,0,132,0,0,0,0,0,0,0,43,0,194,0,96,0,104,0,0,0,93,0,11,0,175,0,200,0,17,0,192,0,0,0,0,0,126,0,0,0,0,0,0,0,92,0,116,0,105,0,0,0,222,0,73,0,7,0,0,0,125,0,203,0,124,0,88,0,194,0,0,0,218,0,51,0,45,0,4,0,143,0,151,0,57,0,123,0,73,0,0,0,0,0,225,0,170,0,31,0,114,0,0,0,0,0,2,0,115,0,56,0,121,0,64,0,70,0,174,0,170,0,127,0,88,0,254,0,199,0,11,0,181,0,74,0,40,0,0,0,69,0,0,0,102,0,47,0,214,0,48,0,73,0,143,0,31,0,100,0,166,0,81,0,241,0,175,0,49,0,210,0,185,0,31,0,170,0,225,0,187,0,27,0,137,0,97,0,53,0,23,0,244,0,96,0,164,0,228,0,118,0,180,0,0,0,152,0,180,0,0,0,174,0,5,0,66,0,132,0,88,0,98,0,93,0,219,0,0,0,0,0,129,0,200,0,0,0,8,0,207,0,144,0,200,0,88,0,211,0,212,0,192,0,106,0,0,0,168,0,237,0,15,0,225,0,0,0,132,0,106,0,146,0,85,0,121,0,125,0,0,0,65,0,171,0,89,0,201,0,49,0,190,0,189,0,93,0,7,0,162,0,132,0,137,0,97,0,46,0,37,0,158,0,27,0,41,0,0,0,143,0,0,0,248,0,196,0,0,0,225,0,31,0,188,0,79,0,0,0,205,0,22,0,0,0,0,0,238,0,0,0,90,0,153,0,90,0,154,0,184,0,241,0,136,0,139,0,227,0,0,0,0,0,239,0,201,0,115,0,155,0,1,0,37,0,202,0,97,0,210,0,0,0,39,0,126,0,20,0,174,0,195,0,116,0,123,0,17,0,102,0,37,0,154,0,23,0,86,0,187,0,209,0,39,0,84,0);
signal scenario_full  : scenario_type := (110,31,110,30,40,31,73,31,135,31,135,30,121,31,77,31,208,31,201,31,98,31,113,31,31,31,31,30,240,31,156,31,15,31,190,31,190,30,60,31,223,31,86,31,86,30,39,31,39,30,39,29,103,31,103,30,62,31,31,31,143,31,143,30,143,29,66,31,29,31,246,31,102,31,212,31,108,31,108,30,93,31,83,31,208,31,206,31,206,30,162,31,90,31,84,31,211,31,142,31,72,31,149,31,177,31,59,31,63,31,168,31,168,30,168,29,89,31,86,31,86,30,86,29,49,31,21,31,85,31,237,31,56,31,56,30,186,31,244,31,240,31,84,31,107,31,142,31,142,30,142,29,53,31,229,31,229,30,155,31,242,31,88,31,123,31,69,31,158,31,60,31,200,31,170,31,63,31,239,31,110,31,214,31,206,31,76,31,115,31,44,31,241,31,241,30,73,31,138,31,29,31,93,31,93,30,93,29,79,31,193,31,25,31,84,31,18,31,40,31,103,31,87,31,217,31,161,31,131,31,59,31,59,30,73,31,2,31,2,30,71,31,146,31,243,31,229,31,158,31,158,30,221,31,204,31,20,31,20,30,40,31,89,31,89,30,140,31,165,31,35,31,14,31,130,31,68,31,214,31,214,30,214,29,82,31,37,31,19,31,233,31,254,31,164,31,55,31,38,31,38,30,38,29,34,31,34,30,109,31,109,31,109,30,109,29,21,31,212,31,143,31,143,30,165,31,116,31,196,31,196,30,66,31,66,30,13,31,173,31,27,31,27,30,142,31,136,31,252,31,67,31,67,30,242,31,227,31,232,31,216,31,206,31,79,31,71,31,71,30,79,31,79,30,100,31,50,31,202,31,211,31,20,31,51,31,109,31,230,31,239,31,113,31,190,31,190,30,190,29,227,31,249,31,179,31,217,31,28,31,224,31,186,31,107,31,181,31,39,31,93,31,93,30,198,31,93,31,73,31,73,30,254,31,139,31,4,31,4,30,136,31,125,31,216,31,251,31,34,31,34,30,129,31,1,31,127,31,169,31,169,30,211,31,211,30,125,31,2,31,196,31,14,31,214,31,126,31,70,31,43,31,132,31,249,31,127,31,246,31,82,31,154,31,154,30,5,31,231,31,74,31,72,31,94,31,94,30,5,31,204,31,186,31,213,31,213,30,70,31,239,31,226,31,212,31,29,31,187,31,20,31,20,30,160,31,160,31,64,31,139,31,235,31,10,31,10,30,62,31,62,30,62,29,62,28,34,31,140,31,24,31,33,31,192,31,11,31,171,31,203,31,203,30,67,31,150,31,222,31,14,31,183,31,144,31,107,31,107,30,65,31,54,31,100,31,52,31,130,31,139,31,139,30,139,29,124,31,132,31,132,30,132,29,132,28,43,31,194,31,96,31,104,31,104,30,93,31,11,31,175,31,200,31,17,31,192,31,192,30,192,29,126,31,126,30,126,29,126,28,92,31,116,31,105,31,105,30,222,31,73,31,7,31,7,30,125,31,203,31,124,31,88,31,194,31,194,30,218,31,51,31,45,31,4,31,143,31,151,31,57,31,123,31,73,31,73,30,73,29,225,31,170,31,31,31,114,31,114,30,114,29,2,31,115,31,56,31,121,31,64,31,70,31,174,31,170,31,127,31,88,31,254,31,199,31,11,31,181,31,74,31,40,31,40,30,69,31,69,30,102,31,47,31,214,31,48,31,73,31,143,31,31,31,100,31,166,31,81,31,241,31,175,31,49,31,210,31,185,31,31,31,170,31,225,31,187,31,27,31,137,31,97,31,53,31,23,31,244,31,96,31,164,31,228,31,118,31,180,31,180,30,152,31,180,31,180,30,174,31,5,31,66,31,132,31,88,31,98,31,93,31,219,31,219,30,219,29,129,31,200,31,200,30,8,31,207,31,144,31,200,31,88,31,211,31,212,31,192,31,106,31,106,30,168,31,237,31,15,31,225,31,225,30,132,31,106,31,146,31,85,31,121,31,125,31,125,30,65,31,171,31,89,31,201,31,49,31,190,31,189,31,93,31,7,31,162,31,132,31,137,31,97,31,46,31,37,31,158,31,27,31,41,31,41,30,143,31,143,30,248,31,196,31,196,30,225,31,31,31,188,31,79,31,79,30,205,31,22,31,22,30,22,29,238,31,238,30,90,31,153,31,90,31,154,31,184,31,241,31,136,31,139,31,227,31,227,30,227,29,239,31,201,31,115,31,155,31,1,31,37,31,202,31,97,31,210,31,210,30,39,31,126,31,20,31,174,31,195,31,116,31,123,31,17,31,102,31,37,31,154,31,23,31,86,31,187,31,209,31,39,31,84,31);

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
