-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_330 is
end project_tb_330;

architecture project_tb_arch_330 of project_tb_330 is
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

constant SCENARIO_LENGTH : integer := 268;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (138,0,0,0,221,0,87,0,36,0,193,0,95,0,50,0,24,0,3,0,82,0,13,0,168,0,87,0,0,0,254,0,0,0,0,0,253,0,219,0,163,0,0,0,102,0,0,0,232,0,195,0,0,0,0,0,85,0,0,0,120,0,185,0,0,0,63,0,188,0,180,0,117,0,156,0,0,0,22,0,0,0,96,0,138,0,15,0,247,0,100,0,183,0,4,0,167,0,146,0,137,0,129,0,0,0,0,0,74,0,31,0,135,0,33,0,91,0,23,0,130,0,0,0,130,0,205,0,52,0,34,0,13,0,117,0,0,0,0,0,207,0,7,0,128,0,228,0,0,0,142,0,0,0,0,0,182,0,99,0,227,0,242,0,0,0,0,0,0,0,89,0,1,0,57,0,0,0,251,0,239,0,4,0,140,0,0,0,0,0,100,0,178,0,102,0,26,0,131,0,68,0,194,0,204,0,219,0,141,0,34,0,0,0,92,0,25,0,0,0,0,0,220,0,140,0,0,0,101,0,93,0,77,0,132,0,2,0,225,0,56,0,121,0,240,0,0,0,214,0,148,0,251,0,125,0,219,0,0,0,29,0,0,0,251,0,0,0,154,0,169,0,20,0,48,0,78,0,250,0,0,0,229,0,248,0,65,0,45,0,0,0,0,0,0,0,35,0,79,0,154,0,96,0,84,0,0,0,102,0,227,0,92,0,88,0,208,0,87,0,60,0,15,0,191,0,7,0,145,0,0,0,182,0,234,0,0,0,125,0,75,0,169,0,54,0,147,0,196,0,0,0,47,0,128,0,165,0,58,0,117,0,169,0,0,0,153,0,0,0,118,0,102,0,0,0,88,0,13,0,47,0,28,0,36,0,208,0,20,0,225,0,0,0,93,0,195,0,27,0,0,0,94,0,0,0,224,0,0,0,66,0,173,0,70,0,111,0,68,0,132,0,0,0,191,0,0,0,83,0,55,0,19,0,123,0,128,0,197,0,60,0,0,0,0,0,206,0,106,0,193,0,0,0,10,0,197,0,55,0,164,0,230,0,214,0,0,0,158,0,0,0,32,0,0,0,74,0,163,0,220,0,207,0,194,0,47,0,104,0,246,0,0,0,11,0,112,0,237,0,200,0,108,0,0,0,69,0,141,0,55,0,16,0,159,0,243,0,99,0,34,0,0,0,194,0,238,0,131,0,179,0,113,0,109,0);
signal scenario_full  : scenario_type := (138,31,138,30,221,31,87,31,36,31,193,31,95,31,50,31,24,31,3,31,82,31,13,31,168,31,87,31,87,30,254,31,254,30,254,29,253,31,219,31,163,31,163,30,102,31,102,30,232,31,195,31,195,30,195,29,85,31,85,30,120,31,185,31,185,30,63,31,188,31,180,31,117,31,156,31,156,30,22,31,22,30,96,31,138,31,15,31,247,31,100,31,183,31,4,31,167,31,146,31,137,31,129,31,129,30,129,29,74,31,31,31,135,31,33,31,91,31,23,31,130,31,130,30,130,31,205,31,52,31,34,31,13,31,117,31,117,30,117,29,207,31,7,31,128,31,228,31,228,30,142,31,142,30,142,29,182,31,99,31,227,31,242,31,242,30,242,29,242,28,89,31,1,31,57,31,57,30,251,31,239,31,4,31,140,31,140,30,140,29,100,31,178,31,102,31,26,31,131,31,68,31,194,31,204,31,219,31,141,31,34,31,34,30,92,31,25,31,25,30,25,29,220,31,140,31,140,30,101,31,93,31,77,31,132,31,2,31,225,31,56,31,121,31,240,31,240,30,214,31,148,31,251,31,125,31,219,31,219,30,29,31,29,30,251,31,251,30,154,31,169,31,20,31,48,31,78,31,250,31,250,30,229,31,248,31,65,31,45,31,45,30,45,29,45,28,35,31,79,31,154,31,96,31,84,31,84,30,102,31,227,31,92,31,88,31,208,31,87,31,60,31,15,31,191,31,7,31,145,31,145,30,182,31,234,31,234,30,125,31,75,31,169,31,54,31,147,31,196,31,196,30,47,31,128,31,165,31,58,31,117,31,169,31,169,30,153,31,153,30,118,31,102,31,102,30,88,31,13,31,47,31,28,31,36,31,208,31,20,31,225,31,225,30,93,31,195,31,27,31,27,30,94,31,94,30,224,31,224,30,66,31,173,31,70,31,111,31,68,31,132,31,132,30,191,31,191,30,83,31,55,31,19,31,123,31,128,31,197,31,60,31,60,30,60,29,206,31,106,31,193,31,193,30,10,31,197,31,55,31,164,31,230,31,214,31,214,30,158,31,158,30,32,31,32,30,74,31,163,31,220,31,207,31,194,31,47,31,104,31,246,31,246,30,11,31,112,31,237,31,200,31,108,31,108,30,69,31,141,31,55,31,16,31,159,31,243,31,99,31,34,31,34,30,194,31,238,31,131,31,179,31,113,31,109,31);

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
