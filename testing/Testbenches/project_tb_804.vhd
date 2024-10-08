-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_804 is
end project_tb_804;

architecture project_tb_arch_804 of project_tb_804 is
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

constant SCENARIO_LENGTH : integer := 340;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,232,0,207,0,169,0,59,0,169,0,162,0,61,0,0,0,130,0,0,0,0,0,103,0,93,0,162,0,38,0,0,0,127,0,173,0,0,0,58,0,183,0,72,0,87,0,172,0,29,0,0,0,79,0,207,0,14,0,31,0,144,0,30,0,237,0,0,0,44,0,163,0,49,0,15,0,204,0,0,0,236,0,99,0,246,0,61,0,0,0,0,0,127,0,0,0,214,0,0,0,0,0,69,0,199,0,205,0,186,0,202,0,208,0,234,0,0,0,0,0,176,0,219,0,215,0,0,0,239,0,0,0,85,0,21,0,121,0,168,0,79,0,47,0,117,0,231,0,150,0,58,0,20,0,7,0,233,0,149,0,229,0,74,0,60,0,0,0,52,0,163,0,87,0,0,0,112,0,0,0,130,0,118,0,0,0,0,0,156,0,112,0,191,0,73,0,230,0,227,0,0,0,0,0,90,0,12,0,158,0,153,0,139,0,15,0,131,0,151,0,0,0,50,0,202,0,211,0,245,0,19,0,207,0,110,0,47,0,9,0,61,0,43,0,0,0,77,0,242,0,9,0,0,0,189,0,0,0,72,0,120,0,192,0,84,0,33,0,205,0,0,0,84,0,0,0,0,0,159,0,0,0,115,0,116,0,55,0,176,0,16,0,156,0,0,0,222,0,151,0,170,0,140,0,129,0,0,0,116,0,0,0,189,0,63,0,186,0,99,0,248,0,0,0,184,0,69,0,0,0,192,0,157,0,87,0,250,0,242,0,123,0,0,0,0,0,199,0,179,0,203,0,148,0,93,0,74,0,0,0,154,0,200,0,130,0,118,0,232,0,13,0,170,0,89,0,193,0,238,0,18,0,137,0,58,0,183,0,164,0,247,0,185,0,91,0,134,0,149,0,0,0,0,0,153,0,0,0,0,0,0,0,38,0,174,0,242,0,114,0,135,0,152,0,0,0,164,0,219,0,95,0,70,0,139,0,110,0,47,0,244,0,31,0,127,0,13,0,157,0,100,0,250,0,205,0,0,0,0,0,0,0,38,0,40,0,100,0,118,0,0,0,0,0,197,0,0,0,0,0,205,0,155,0,184,0,20,0,193,0,77,0,51,0,0,0,76,0,138,0,168,0,180,0,216,0,8,0,239,0,202,0,233,0,126,0,223,0,56,0,194,0,0,0,179,0,0,0,27,0,108,0,1,0,145,0,167,0,238,0,157,0,0,0,0,0,210,0,189,0,168,0,74,0,254,0,98,0,0,0,0,0,202,0,254,0,39,0,138,0,181,0,167,0,18,0,186,0,48,0,58,0,217,0,204,0,171,0,151,0,37,0,0,0,85,0,176,0,244,0,130,0,66,0,212,0,106,0,53,0,187,0,105,0,229,0,0,0,193,0,7,0,196,0,0,0,27,0,79,0,114,0,9,0,117,0,0,0,64,0,239,0,0,0,21,0,0,0,146,0,0,0,12,0,0,0,110,0,226,0,172,0,214,0,0,0,0,0,196,0,208,0,131,0,144,0,0,0);
signal scenario_full  : scenario_type := (0,0,232,31,207,31,169,31,59,31,169,31,162,31,61,31,61,30,130,31,130,30,130,29,103,31,93,31,162,31,38,31,38,30,127,31,173,31,173,30,58,31,183,31,72,31,87,31,172,31,29,31,29,30,79,31,207,31,14,31,31,31,144,31,30,31,237,31,237,30,44,31,163,31,49,31,15,31,204,31,204,30,236,31,99,31,246,31,61,31,61,30,61,29,127,31,127,30,214,31,214,30,214,29,69,31,199,31,205,31,186,31,202,31,208,31,234,31,234,30,234,29,176,31,219,31,215,31,215,30,239,31,239,30,85,31,21,31,121,31,168,31,79,31,47,31,117,31,231,31,150,31,58,31,20,31,7,31,233,31,149,31,229,31,74,31,60,31,60,30,52,31,163,31,87,31,87,30,112,31,112,30,130,31,118,31,118,30,118,29,156,31,112,31,191,31,73,31,230,31,227,31,227,30,227,29,90,31,12,31,158,31,153,31,139,31,15,31,131,31,151,31,151,30,50,31,202,31,211,31,245,31,19,31,207,31,110,31,47,31,9,31,61,31,43,31,43,30,77,31,242,31,9,31,9,30,189,31,189,30,72,31,120,31,192,31,84,31,33,31,205,31,205,30,84,31,84,30,84,29,159,31,159,30,115,31,116,31,55,31,176,31,16,31,156,31,156,30,222,31,151,31,170,31,140,31,129,31,129,30,116,31,116,30,189,31,63,31,186,31,99,31,248,31,248,30,184,31,69,31,69,30,192,31,157,31,87,31,250,31,242,31,123,31,123,30,123,29,199,31,179,31,203,31,148,31,93,31,74,31,74,30,154,31,200,31,130,31,118,31,232,31,13,31,170,31,89,31,193,31,238,31,18,31,137,31,58,31,183,31,164,31,247,31,185,31,91,31,134,31,149,31,149,30,149,29,153,31,153,30,153,29,153,28,38,31,174,31,242,31,114,31,135,31,152,31,152,30,164,31,219,31,95,31,70,31,139,31,110,31,47,31,244,31,31,31,127,31,13,31,157,31,100,31,250,31,205,31,205,30,205,29,205,28,38,31,40,31,100,31,118,31,118,30,118,29,197,31,197,30,197,29,205,31,155,31,184,31,20,31,193,31,77,31,51,31,51,30,76,31,138,31,168,31,180,31,216,31,8,31,239,31,202,31,233,31,126,31,223,31,56,31,194,31,194,30,179,31,179,30,27,31,108,31,1,31,145,31,167,31,238,31,157,31,157,30,157,29,210,31,189,31,168,31,74,31,254,31,98,31,98,30,98,29,202,31,254,31,39,31,138,31,181,31,167,31,18,31,186,31,48,31,58,31,217,31,204,31,171,31,151,31,37,31,37,30,85,31,176,31,244,31,130,31,66,31,212,31,106,31,53,31,187,31,105,31,229,31,229,30,193,31,7,31,196,31,196,30,27,31,79,31,114,31,9,31,117,31,117,30,64,31,239,31,239,30,21,31,21,30,146,31,146,30,12,31,12,30,110,31,226,31,172,31,214,31,214,30,214,29,196,31,208,31,131,31,144,31,144,30);

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
