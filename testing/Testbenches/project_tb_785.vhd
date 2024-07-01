-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_785 is
end project_tb_785;

architecture project_tb_arch_785 of project_tb_785 is
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

constant SCENARIO_LENGTH : integer := 434;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (53,0,66,0,82,0,0,0,95,0,127,0,115,0,0,0,223,0,143,0,251,0,230,0,176,0,126,0,0,0,25,0,0,0,0,0,22,0,70,0,180,0,11,0,153,0,82,0,0,0,217,0,0,0,31,0,122,0,237,0,108,0,67,0,80,0,83,0,81,0,223,0,145,0,24,0,0,0,87,0,138,0,186,0,0,0,222,0,11,0,45,0,87,0,0,0,116,0,29,0,13,0,15,0,132,0,0,0,226,0,71,0,219,0,45,0,44,0,42,0,145,0,48,0,147,0,93,0,44,0,80,0,221,0,22,0,251,0,107,0,204,0,195,0,116,0,41,0,205,0,228,0,104,0,0,0,0,0,12,0,0,0,54,0,152,0,0,0,171,0,181,0,0,0,58,0,93,0,187,0,0,0,254,0,249,0,131,0,163,0,131,0,0,0,3,0,0,0,148,0,208,0,193,0,115,0,7,0,137,0,0,0,71,0,168,0,0,0,100,0,220,0,231,0,110,0,254,0,0,0,0,0,58,0,77,0,125,0,0,0,76,0,63,0,111,0,151,0,108,0,202,0,15,0,19,0,94,0,194,0,0,0,78,0,34,0,89,0,27,0,150,0,183,0,189,0,212,0,0,0,40,0,48,0,237,0,12,0,117,0,42,0,244,0,203,0,219,0,187,0,197,0,81,0,150,0,191,0,0,0,190,0,152,0,206,0,0,0,183,0,165,0,0,0,53,0,159,0,0,0,84,0,184,0,227,0,194,0,205,0,65,0,60,0,79,0,44,0,0,0,0,0,6,0,63,0,75,0,52,0,250,0,0,0,97,0,91,0,6,0,0,0,25,0,70,0,0,0,20,0,67,0,118,0,97,0,0,0,131,0,242,0,31,0,0,0,161,0,43,0,28,0,163,0,10,0,0,0,43,0,134,0,165,0,115,0,187,0,170,0,0,0,182,0,0,0,88,0,114,0,78,0,112,0,224,0,28,0,241,0,17,0,146,0,178,0,46,0,161,0,31,0,43,0,32,0,225,0,0,0,42,0,249,0,98,0,0,0,112,0,240,0,70,0,8,0,176,0,91,0,17,0,0,0,0,0,143,0,46,0,164,0,0,0,0,0,100,0,197,0,202,0,233,0,238,0,92,0,0,0,204,0,0,0,0,0,206,0,240,0,107,0,203,0,0,0,64,0,0,0,1,0,129,0,18,0,198,0,142,0,0,0,6,0,28,0,45,0,190,0,73,0,208,0,191,0,145,0,0,0,31,0,224,0,181,0,146,0,0,0,1,0,185,0,65,0,109,0,236,0,200,0,187,0,164,0,165,0,37,0,222,0,205,0,57,0,127,0,0,0,8,0,189,0,0,0,182,0,34,0,201,0,224,0,41,0,232,0,69,0,161,0,198,0,70,0,167,0,230,0,168,0,0,0,36,0,21,0,0,0,45,0,0,0,179,0,0,0,165,0,203,0,169,0,255,0,81,0,61,0,98,0,95,0,10,0,74,0,0,0,0,0,213,0,226,0,246,0,100,0,0,0,97,0,0,0,252,0,0,0,247,0,90,0,245,0,151,0,234,0,0,0,0,0,237,0,189,0,102,0,192,0,0,0,153,0,0,0,123,0,50,0,0,0,218,0,0,0,88,0,0,0,216,0,0,0,17,0,2,0,0,0,210,0,0,0,172,0,165,0,0,0,37,0,23,0,95,0,27,0,126,0,200,0,253,0,188,0,196,0,0,0,41,0,119,0,34,0,23,0,213,0,66,0,38,0,245,0,8,0,226,0,152,0,0,0,183,0,61,0,0,0,45,0,181,0,0,0,80,0,120,0,173,0,178,0,147,0,0,0,74,0,22,0,24,0,206,0,68,0,89,0,250,0,85,0,21,0,8,0,2,0,0,0,47,0,173,0,173,0,11,0,80,0,60,0,104,0,0,0,207,0,29,0,0,0,78,0);
signal scenario_full  : scenario_type := (53,31,66,31,82,31,82,30,95,31,127,31,115,31,115,30,223,31,143,31,251,31,230,31,176,31,126,31,126,30,25,31,25,30,25,29,22,31,70,31,180,31,11,31,153,31,82,31,82,30,217,31,217,30,31,31,122,31,237,31,108,31,67,31,80,31,83,31,81,31,223,31,145,31,24,31,24,30,87,31,138,31,186,31,186,30,222,31,11,31,45,31,87,31,87,30,116,31,29,31,13,31,15,31,132,31,132,30,226,31,71,31,219,31,45,31,44,31,42,31,145,31,48,31,147,31,93,31,44,31,80,31,221,31,22,31,251,31,107,31,204,31,195,31,116,31,41,31,205,31,228,31,104,31,104,30,104,29,12,31,12,30,54,31,152,31,152,30,171,31,181,31,181,30,58,31,93,31,187,31,187,30,254,31,249,31,131,31,163,31,131,31,131,30,3,31,3,30,148,31,208,31,193,31,115,31,7,31,137,31,137,30,71,31,168,31,168,30,100,31,220,31,231,31,110,31,254,31,254,30,254,29,58,31,77,31,125,31,125,30,76,31,63,31,111,31,151,31,108,31,202,31,15,31,19,31,94,31,194,31,194,30,78,31,34,31,89,31,27,31,150,31,183,31,189,31,212,31,212,30,40,31,48,31,237,31,12,31,117,31,42,31,244,31,203,31,219,31,187,31,197,31,81,31,150,31,191,31,191,30,190,31,152,31,206,31,206,30,183,31,165,31,165,30,53,31,159,31,159,30,84,31,184,31,227,31,194,31,205,31,65,31,60,31,79,31,44,31,44,30,44,29,6,31,63,31,75,31,52,31,250,31,250,30,97,31,91,31,6,31,6,30,25,31,70,31,70,30,20,31,67,31,118,31,97,31,97,30,131,31,242,31,31,31,31,30,161,31,43,31,28,31,163,31,10,31,10,30,43,31,134,31,165,31,115,31,187,31,170,31,170,30,182,31,182,30,88,31,114,31,78,31,112,31,224,31,28,31,241,31,17,31,146,31,178,31,46,31,161,31,31,31,43,31,32,31,225,31,225,30,42,31,249,31,98,31,98,30,112,31,240,31,70,31,8,31,176,31,91,31,17,31,17,30,17,29,143,31,46,31,164,31,164,30,164,29,100,31,197,31,202,31,233,31,238,31,92,31,92,30,204,31,204,30,204,29,206,31,240,31,107,31,203,31,203,30,64,31,64,30,1,31,129,31,18,31,198,31,142,31,142,30,6,31,28,31,45,31,190,31,73,31,208,31,191,31,145,31,145,30,31,31,224,31,181,31,146,31,146,30,1,31,185,31,65,31,109,31,236,31,200,31,187,31,164,31,165,31,37,31,222,31,205,31,57,31,127,31,127,30,8,31,189,31,189,30,182,31,34,31,201,31,224,31,41,31,232,31,69,31,161,31,198,31,70,31,167,31,230,31,168,31,168,30,36,31,21,31,21,30,45,31,45,30,179,31,179,30,165,31,203,31,169,31,255,31,81,31,61,31,98,31,95,31,10,31,74,31,74,30,74,29,213,31,226,31,246,31,100,31,100,30,97,31,97,30,252,31,252,30,247,31,90,31,245,31,151,31,234,31,234,30,234,29,237,31,189,31,102,31,192,31,192,30,153,31,153,30,123,31,50,31,50,30,218,31,218,30,88,31,88,30,216,31,216,30,17,31,2,31,2,30,210,31,210,30,172,31,165,31,165,30,37,31,23,31,95,31,27,31,126,31,200,31,253,31,188,31,196,31,196,30,41,31,119,31,34,31,23,31,213,31,66,31,38,31,245,31,8,31,226,31,152,31,152,30,183,31,61,31,61,30,45,31,181,31,181,30,80,31,120,31,173,31,178,31,147,31,147,30,74,31,22,31,24,31,206,31,68,31,89,31,250,31,85,31,21,31,8,31,2,31,2,30,47,31,173,31,173,31,11,31,80,31,60,31,104,31,104,30,207,31,29,31,29,30,78,31);

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
