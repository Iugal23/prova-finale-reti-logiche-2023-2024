-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_805 is
end project_tb_805;

architecture project_tb_arch_805 of project_tb_805 is
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

constant SCENARIO_LENGTH : integer := 308;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,225,0,120,0,0,0,43,0,73,0,79,0,223,0,38,0,66,0,36,0,34,0,0,0,104,0,239,0,70,0,0,0,152,0,159,0,0,0,188,0,171,0,83,0,162,0,36,0,53,0,150,0,244,0,70,0,67,0,51,0,0,0,0,0,203,0,130,0,235,0,181,0,240,0,250,0,142,0,0,0,0,0,202,0,252,0,28,0,0,0,157,0,147,0,0,0,111,0,22,0,0,0,174,0,163,0,212,0,206,0,162,0,0,0,113,0,51,0,197,0,241,0,92,0,44,0,142,0,32,0,232,0,168,0,176,0,135,0,207,0,82,0,216,0,3,0,223,0,219,0,5,0,214,0,104,0,62,0,0,0,218,0,127,0,0,0,0,0,51,0,105,0,99,0,40,0,105,0,205,0,114,0,189,0,58,0,0,0,113,0,0,0,242,0,114,0,0,0,49,0,165,0,158,0,221,0,0,0,6,0,229,0,31,0,122,0,163,0,0,0,230,0,83,0,18,0,0,0,0,0,124,0,230,0,110,0,168,0,79,0,0,0,201,0,239,0,0,0,0,0,0,0,26,0,222,0,15,0,148,0,170,0,0,0,153,0,111,0,162,0,132,0,0,0,94,0,154,0,121,0,0,0,118,0,8,0,22,0,118,0,0,0,126,0,245,0,0,0,29,0,157,0,205,0,22,0,0,0,47,0,0,0,225,0,0,0,45,0,0,0,0,0,23,0,96,0,0,0,57,0,84,0,214,0,140,0,128,0,110,0,25,0,135,0,134,0,10,0,0,0,0,0,224,0,247,0,0,0,103,0,156,0,61,0,0,0,195,0,211,0,250,0,134,0,219,0,132,0,253,0,248,0,1,0,171,0,0,0,224,0,132,0,177,0,190,0,127,0,83,0,172,0,247,0,144,0,154,0,0,0,0,0,0,0,56,0,65,0,0,0,0,0,0,0,142,0,227,0,26,0,226,0,18,0,150,0,0,0,142,0,163,0,8,0,99,0,158,0,250,0,83,0,0,0,0,0,52,0,226,0,178,0,75,0,207,0,175,0,0,0,198,0,212,0,185,0,36,0,151,0,76,0,117,0,22,0,146,0,144,0,105,0,142,0,32,0,24,0,0,0,89,0,223,0,0,0,47,0,102,0,78,0,127,0,124,0,0,0,189,0,135,0,241,0,177,0,78,0,72,0,149,0,113,0,0,0,158,0,128,0,0,0,34,0,0,0,62,0,71,0,217,0,55,0,10,0,0,0,232,0,247,0,16,0,250,0,102,0,245,0,193,0,11,0,0,0,233,0,105,0,71,0,176,0,242,0,32,0,82,0,0,0,82,0,59,0,31,0,69,0,0,0,152,0,0,0,233,0,57,0,0,0,200,0);
signal scenario_full  : scenario_type := (0,0,225,31,120,31,120,30,43,31,73,31,79,31,223,31,38,31,66,31,36,31,34,31,34,30,104,31,239,31,70,31,70,30,152,31,159,31,159,30,188,31,171,31,83,31,162,31,36,31,53,31,150,31,244,31,70,31,67,31,51,31,51,30,51,29,203,31,130,31,235,31,181,31,240,31,250,31,142,31,142,30,142,29,202,31,252,31,28,31,28,30,157,31,147,31,147,30,111,31,22,31,22,30,174,31,163,31,212,31,206,31,162,31,162,30,113,31,51,31,197,31,241,31,92,31,44,31,142,31,32,31,232,31,168,31,176,31,135,31,207,31,82,31,216,31,3,31,223,31,219,31,5,31,214,31,104,31,62,31,62,30,218,31,127,31,127,30,127,29,51,31,105,31,99,31,40,31,105,31,205,31,114,31,189,31,58,31,58,30,113,31,113,30,242,31,114,31,114,30,49,31,165,31,158,31,221,31,221,30,6,31,229,31,31,31,122,31,163,31,163,30,230,31,83,31,18,31,18,30,18,29,124,31,230,31,110,31,168,31,79,31,79,30,201,31,239,31,239,30,239,29,239,28,26,31,222,31,15,31,148,31,170,31,170,30,153,31,111,31,162,31,132,31,132,30,94,31,154,31,121,31,121,30,118,31,8,31,22,31,118,31,118,30,126,31,245,31,245,30,29,31,157,31,205,31,22,31,22,30,47,31,47,30,225,31,225,30,45,31,45,30,45,29,23,31,96,31,96,30,57,31,84,31,214,31,140,31,128,31,110,31,25,31,135,31,134,31,10,31,10,30,10,29,224,31,247,31,247,30,103,31,156,31,61,31,61,30,195,31,211,31,250,31,134,31,219,31,132,31,253,31,248,31,1,31,171,31,171,30,224,31,132,31,177,31,190,31,127,31,83,31,172,31,247,31,144,31,154,31,154,30,154,29,154,28,56,31,65,31,65,30,65,29,65,28,142,31,227,31,26,31,226,31,18,31,150,31,150,30,142,31,163,31,8,31,99,31,158,31,250,31,83,31,83,30,83,29,52,31,226,31,178,31,75,31,207,31,175,31,175,30,198,31,212,31,185,31,36,31,151,31,76,31,117,31,22,31,146,31,144,31,105,31,142,31,32,31,24,31,24,30,89,31,223,31,223,30,47,31,102,31,78,31,127,31,124,31,124,30,189,31,135,31,241,31,177,31,78,31,72,31,149,31,113,31,113,30,158,31,128,31,128,30,34,31,34,30,62,31,71,31,217,31,55,31,10,31,10,30,232,31,247,31,16,31,250,31,102,31,245,31,193,31,11,31,11,30,233,31,105,31,71,31,176,31,242,31,32,31,82,31,82,30,82,31,59,31,31,31,69,31,69,30,152,31,152,30,233,31,57,31,57,30,200,31);

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
