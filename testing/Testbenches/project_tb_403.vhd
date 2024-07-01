-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_403 is
end project_tb_403;

architecture project_tb_arch_403 of project_tb_403 is
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

constant SCENARIO_LENGTH : integer := 459;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (87,0,115,0,170,0,140,0,225,0,20,0,198,0,194,0,50,0,0,0,0,0,0,0,82,0,232,0,62,0,126,0,0,0,0,0,84,0,247,0,166,0,179,0,37,0,216,0,13,0,0,0,169,0,190,0,141,0,0,0,118,0,143,0,63,0,31,0,253,0,0,0,73,0,227,0,196,0,73,0,248,0,211,0,59,0,176,0,49,0,127,0,0,0,148,0,0,0,81,0,188,0,239,0,0,0,66,0,0,0,86,0,80,0,0,0,0,0,224,0,0,0,124,0,91,0,173,0,150,0,138,0,59,0,161,0,52,0,104,0,161,0,106,0,138,0,216,0,38,0,90,0,134,0,85,0,33,0,165,0,0,0,71,0,137,0,0,0,100,0,148,0,146,0,39,0,168,0,233,0,21,0,38,0,213,0,0,0,196,0,117,0,47,0,128,0,80,0,0,0,121,0,202,0,68,0,16,0,201,0,86,0,111,0,43,0,179,0,229,0,47,0,0,0,119,0,120,0,0,0,0,0,75,0,201,0,233,0,180,0,145,0,59,0,0,0,50,0,217,0,34,0,62,0,85,0,0,0,66,0,187,0,12,0,40,0,234,0,214,0,139,0,166,0,149,0,180,0,190,0,220,0,44,0,110,0,100,0,189,0,23,0,53,0,249,0,0,0,241,0,10,0,0,0,63,0,42,0,0,0,148,0,0,0,88,0,0,0,0,0,132,0,0,0,44,0,0,0,14,0,152,0,97,0,254,0,108,0,85,0,157,0,142,0,0,0,164,0,183,0,0,0,0,0,100,0,76,0,0,0,0,0,245,0,225,0,25,0,88,0,225,0,0,0,222,0,0,0,203,0,61,0,215,0,143,0,33,0,237,0,0,0,29,0,234,0,189,0,213,0,106,0,28,0,0,0,83,0,5,0,214,0,0,0,91,0,213,0,105,0,42,0,164,0,109,0,73,0,215,0,56,0,219,0,138,0,0,0,109,0,164,0,0,0,159,0,221,0,210,0,114,0,20,0,0,0,212,0,180,0,99,0,0,0,153,0,187,0,161,0,239,0,127,0,21,0,95,0,178,0,165,0,217,0,0,0,109,0,29,0,29,0,0,0,253,0,60,0,229,0,91,0,232,0,0,0,2,0,132,0,224,0,92,0,93,0,97,0,0,0,0,0,16,0,135,0,0,0,147,0,124,0,76,0,236,0,197,0,255,0,37,0,132,0,6,0,202,0,103,0,92,0,57,0,108,0,54,0,0,0,25,0,84,0,113,0,219,0,25,0,188,0,173,0,19,0,231,0,104,0,15,0,185,0,49,0,164,0,0,0,140,0,84,0,106,0,69,0,127,0,117,0,0,0,197,0,239,0,231,0,203,0,175,0,95,0,156,0,166,0,0,0,0,0,234,0,161,0,193,0,0,0,233,0,113,0,67,0,59,0,0,0,203,0,130,0,0,0,117,0,84,0,95,0,0,0,193,0,67,0,45,0,0,0,0,0,0,0,0,0,100,0,95,0,156,0,250,0,142,0,243,0,240,0,0,0,7,0,146,0,103,0,246,0,70,0,0,0,194,0,126,0,52,0,0,0,0,0,55,0,114,0,0,0,0,0,103,0,80,0,30,0,196,0,159,0,78,0,216,0,0,0,2,0,3,0,114,0,57,0,207,0,29,0,57,0,29,0,14,0,54,0,92,0,174,0,227,0,0,0,0,0,147,0,217,0,0,0,19,0,209,0,80,0,173,0,183,0,79,0,0,0,206,0,25,0,0,0,125,0,64,0,169,0,47,0,125,0,6,0,118,0,0,0,5,0,189,0,0,0,250,0,57,0,0,0,143,0,16,0,79,0,0,0,0,0,21,0,63,0,0,0,100,0,18,0,63,0,123,0,191,0,0,0,208,0,240,0,29,0,193,0,181,0,151,0,0,0,154,0,0,0,189,0,67,0,155,0,17,0,194,0,252,0,181,0,53,0,195,0,0,0,202,0,61,0,66,0,121,0,0,0,203,0,222,0,68,0,248,0,115,0,176,0,135,0,0,0,238,0,142,0,0,0,240,0,10,0);
signal scenario_full  : scenario_type := (87,31,115,31,170,31,140,31,225,31,20,31,198,31,194,31,50,31,50,30,50,29,50,28,82,31,232,31,62,31,126,31,126,30,126,29,84,31,247,31,166,31,179,31,37,31,216,31,13,31,13,30,169,31,190,31,141,31,141,30,118,31,143,31,63,31,31,31,253,31,253,30,73,31,227,31,196,31,73,31,248,31,211,31,59,31,176,31,49,31,127,31,127,30,148,31,148,30,81,31,188,31,239,31,239,30,66,31,66,30,86,31,80,31,80,30,80,29,224,31,224,30,124,31,91,31,173,31,150,31,138,31,59,31,161,31,52,31,104,31,161,31,106,31,138,31,216,31,38,31,90,31,134,31,85,31,33,31,165,31,165,30,71,31,137,31,137,30,100,31,148,31,146,31,39,31,168,31,233,31,21,31,38,31,213,31,213,30,196,31,117,31,47,31,128,31,80,31,80,30,121,31,202,31,68,31,16,31,201,31,86,31,111,31,43,31,179,31,229,31,47,31,47,30,119,31,120,31,120,30,120,29,75,31,201,31,233,31,180,31,145,31,59,31,59,30,50,31,217,31,34,31,62,31,85,31,85,30,66,31,187,31,12,31,40,31,234,31,214,31,139,31,166,31,149,31,180,31,190,31,220,31,44,31,110,31,100,31,189,31,23,31,53,31,249,31,249,30,241,31,10,31,10,30,63,31,42,31,42,30,148,31,148,30,88,31,88,30,88,29,132,31,132,30,44,31,44,30,14,31,152,31,97,31,254,31,108,31,85,31,157,31,142,31,142,30,164,31,183,31,183,30,183,29,100,31,76,31,76,30,76,29,245,31,225,31,25,31,88,31,225,31,225,30,222,31,222,30,203,31,61,31,215,31,143,31,33,31,237,31,237,30,29,31,234,31,189,31,213,31,106,31,28,31,28,30,83,31,5,31,214,31,214,30,91,31,213,31,105,31,42,31,164,31,109,31,73,31,215,31,56,31,219,31,138,31,138,30,109,31,164,31,164,30,159,31,221,31,210,31,114,31,20,31,20,30,212,31,180,31,99,31,99,30,153,31,187,31,161,31,239,31,127,31,21,31,95,31,178,31,165,31,217,31,217,30,109,31,29,31,29,31,29,30,253,31,60,31,229,31,91,31,232,31,232,30,2,31,132,31,224,31,92,31,93,31,97,31,97,30,97,29,16,31,135,31,135,30,147,31,124,31,76,31,236,31,197,31,255,31,37,31,132,31,6,31,202,31,103,31,92,31,57,31,108,31,54,31,54,30,25,31,84,31,113,31,219,31,25,31,188,31,173,31,19,31,231,31,104,31,15,31,185,31,49,31,164,31,164,30,140,31,84,31,106,31,69,31,127,31,117,31,117,30,197,31,239,31,231,31,203,31,175,31,95,31,156,31,166,31,166,30,166,29,234,31,161,31,193,31,193,30,233,31,113,31,67,31,59,31,59,30,203,31,130,31,130,30,117,31,84,31,95,31,95,30,193,31,67,31,45,31,45,30,45,29,45,28,45,27,100,31,95,31,156,31,250,31,142,31,243,31,240,31,240,30,7,31,146,31,103,31,246,31,70,31,70,30,194,31,126,31,52,31,52,30,52,29,55,31,114,31,114,30,114,29,103,31,80,31,30,31,196,31,159,31,78,31,216,31,216,30,2,31,3,31,114,31,57,31,207,31,29,31,57,31,29,31,14,31,54,31,92,31,174,31,227,31,227,30,227,29,147,31,217,31,217,30,19,31,209,31,80,31,173,31,183,31,79,31,79,30,206,31,25,31,25,30,125,31,64,31,169,31,47,31,125,31,6,31,118,31,118,30,5,31,189,31,189,30,250,31,57,31,57,30,143,31,16,31,79,31,79,30,79,29,21,31,63,31,63,30,100,31,18,31,63,31,123,31,191,31,191,30,208,31,240,31,29,31,193,31,181,31,151,31,151,30,154,31,154,30,189,31,67,31,155,31,17,31,194,31,252,31,181,31,53,31,195,31,195,30,202,31,61,31,66,31,121,31,121,30,203,31,222,31,68,31,248,31,115,31,176,31,135,31,135,30,238,31,142,31,142,30,240,31,10,31);

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
